require_relative 'playlist'
require_relative 'vlcinterface'

class Player
	def initialize()
		@playlist = Playlist.new
		@interface = VLCInterface.new
	end

	def play(uri)
		puts "Uwen server eeft et ook ontvangen. Ge wilt #{uri}"
		#@interface.play @playlist.pop.uri
		@interface.play uri
	end

	def stop
		@interface.stop
	end

	def pause
		@interface.pause
	end

	def is_playing?
		@interface.is_playing?
	end

	def get_title
		@interface.get_title
	end

	def get_time
		@interface.get_time
	end

	def get_length
		@interface.get_length
	end

	def seek(seconds) 
		@interface.seek seconds
	end

	def volume(x)
		@interface.volume x
	end

	def skip
		stop
		play(playlist.pop.uri)
	end

	def flush
		stop
		@playlist.flush
	end

	def magic_shuffle(item)
		@playlist.magic_shuffle(item)
	end

	def shuffle
		@playlist.shuffle
	end

	def dequeue
		@playlist.remove(item)
	end

	def playlist
		@playlist.show
	end

	def history
		@playlist.history
	end

	def enqueue(item)
		@playlist.add(item)
		if is_playing?
			play
		end
	end
end