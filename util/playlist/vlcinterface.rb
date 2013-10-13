class VLCInterface
	def initialize()
		@vlc = IO.popen("vlc -I rc","r+")
		@vlc.puts 'set prompt ""'
		@vlc.puts 'set prompt'
		@vlc.gets
		@vlc.gets
		@vlc.gets
	end

	def close
		@vlc.close
	end

	def add(uri)
		@vlc.puts "add #{uri}"
	end

	def play
		@vlc.puts "play"
	end

	def stop
		@vlc.puts "stop"
	end

	def pause
		@vlc.puts "pause"
	end

	def is_playing? 
		@vlc.puts "is_playing"
		a = @vlc.gets
		a.to_i == 1
	end

	def get_title
		@vlc.puts "get_title"
		@vlc.gets.to_s
	end

	def get_time
		@vlc.puts "get_time"
		@vlc.gets.to_i
	end

	def get_length
		@vlc.puts "get_length"
		@vlc.gets.to_i
	end

	def seek(seconds) 
		@vlc.puts "seek #{seconds}"
	end

	def volume(x)
		@vlc.puts "volume #{x}"
	end
end
