class VLCInterface
	def initialize()
		@vlc = IO.popen("vlc -I rc","r+")
	end

	def close()
		@vlc.close
	end

	def play(uri)
		@vlc.puts "add #{uri}"
	end

	def stop
		@vlc.puts "stop"
	end

	def pause
		@vlc.puts "pause"
	end

	def is_playing?
		@vlc.gets 
		@vlc.puts "is_playing"
		a = @vlc.gets
		puts a
		a.to_i == 1
	end

	def get_title
		@vlc.gets 
		@vlc.puts "get_title"
		@vlc.gets.to_s
	end

	def get_time
		@vlc.gets 
		@vlc.puts "get_time"
		@vlc.gets.to_i
	end

	def get_length
		@vlc.gets 
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
