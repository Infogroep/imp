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
		@vlc.puts "is_playing?"
	end

	def get_title
		@vlc.puts "get_title"
	end

	def get_time
		@vlc.puts "get_time"
	end

	def get_length
		@vlc.puts "get_lenth"
	end

	def seek(seconds) 
		@vlc.puts "seek #{seconds}"
	end

	def volume(x)
		@vlc.puts "volume #{x}"
	end
end
