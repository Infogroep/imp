##
# An implementation of the IMediaPlayer interface.
# This class launches the VideoLAN VLC Media Player as a subprocess
# in remote mode and communicates with it to play media.
class VLCInterface
	##
	# Spawns a VLC process and initializes the connection
	def initialize()
		@vlc = IO.popen("vlc -I rc","r+")
		@vlc.puts 'set prompt ""'
		@vlc.puts 'set prompt'
		@vlc.gets
		@vlc.gets
		@vlc.gets
	end

	##
	# Closes the connection to VLC. This invalidates the VLCInterface object.
	def close
		@vlc.close
	end

	##
	# Play a media file/stream
	def add(uri)
		@vlc.puts "add #{uri}"
	end

	##
	# Start playback
	def play
		@vlc.puts "play"
	end

	##
	# Stop playback
	def stop
		@vlc.puts "stop"
	end

	##
	# Pause playback
	def pause
		@vlc.puts "pause"
	end

	##
	# Check if playback is active
	def is_playing? 
		@vlc.puts "is_playing"
		a = @vlc.gets
		a.to_i == 1
	end

	##
	# Get the title of the current media
	def get_title
		@vlc.puts "get_title"
		@vlc.gets.to_s
	end

	##
	# Get the current position in the media in seconds
	def get_time
		@vlc.puts "get_time"
		@vlc.gets.to_i
	end

	##
	# Get the length of the current media in seconds
	def get_length
		@vlc.puts "get_length"
		@vlc.gets.to_i
	end

	##
	# Skip to a certain time in the current media
	def seek(seconds) 
		@vlc.puts "seek #{seconds}"
	end

	##
	# Set the VLC volume
	def volume(x)
		@vlc.puts "volume #{x}"
	end
end
