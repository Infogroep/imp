require_relative 'playlist'
require_relative 'vlcinterface'
require_relative 'media'

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
		play(@playlist.pop.uri)
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

	def dequeue(item)
		@playlist.remove(item)
	end

	def playlist
		@playlist.show
	end

	def history
		@playlist.history
	end

	def previous
		@playlist.history.pop
		prev = @playlist.history.pop
		@playlist.add(prev)
		@playlist.move_to_front(prev)
		skip
	end

	def replay
		prev = @playlist.history.pop
		@playlist.add(prev)
		@playlist.move_to_front(prev)
		skip
	end
	
	def enqueue(uri)
		#fingerprinting
		item = Media.new uri
		@playlist.add(item)
		#if is_playing?
		#	play
		#end
	end
end