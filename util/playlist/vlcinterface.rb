##
# An implementation of the IMediaPlayer interface.
# This class launches the VideoLAN VLC Media Player as a subprocess
# in remote mode and communicates with it to play media.
class VLCInterface

	##
	# Spawns a VLC process and initializes the connection
	def initialize(on_media_end)
		@vlc = IO.popen("vlc --fullscreen -I rc","r+")
		@vlc.puts 'set prompt ""'
		@vlc.puts 'set prompt'
		@vlc.gets
		@vlc.gets
		@vlc.gets

		@mutex = Mutex.new

		@end_checker = Thread.new do
			while true
				@mutex.lock
				if @should_be_playing and not is_playing?
					@should_be_playing = false
					@mutex.unlock
					on_media_end.call
				else
					@mutex.unlock
				end
				sleep 0.200
			end
		end
	end

	##
	# Closes the connection to VLC. This invalidates the VLCInterface object.
	def close
		@vlc.close
	end

	##
	# Play a media file/stream
	def add(uri)
		synchronized do
			puts "Playing #{uri}"
			@vlc.puts "add #{uri}"
			puts "Waiting for play"
			wait_for_play true
			puts "OK"
		end
	end

	##
	# Start playback
	def play
		synchronized do
			@vlc.puts "play"
			wait_for_play true
		end
	end

	##
	# Stop playback
	def stop
		synchronized do
			@vlc.puts "stop"
			wait_for_play false
		end
	end

	##
	# Pause playback
	def pause
		synchronized do
			@vlc.puts "pause"
		end
	end

	##
	# Check if playback is active
	def is_playing?
		synchronized do
			@vlc.puts "is_playing"
			a = @vlc.gets
			a.to_i == 1
		end
	end

	##
	# Get the title of the current media
	def get_title
		synchronized do
			@vlc.puts "get_title"
			@vlc.gets.to_s
		end
	end

	##
	# Get the current position in the media in seconds
	def get_time
		synchronized do
			@vlc.puts "get_time"
			@vlc.gets.to_i
		end
	end

	##
	# Get the length of the current media in seconds
	def get_length
		synchronized do
			@vlc.puts "get_length"
			@vlc.gets.to_i
		end
	end

	##
	# Skip to a certain time in the current media
	def seek(seconds) 
		synchronized do
			@vlc.puts "seek #{seconds}"
		end
	end

	##
	# Set the VLC volume
	def volume(x)
		synchronized do
			@vlc.puts "volume #{x}"
		end
	end

	private
	
	def wait_for_play(status)
		until status == is_playing?
			sleep 0.020 # do nothing
		end
		@should_be_playing = status
	end

	private
	def synchronized
		if @mutex.owned?
			yield
		else
			@mutex.synchronize do
				yield
			end
		end
	end
end
