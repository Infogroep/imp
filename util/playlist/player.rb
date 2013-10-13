require_relative 'playlist'
require_relative 'vlcinterface'
require_relative 'media'

class Player
	def initialize()
		@playlist = Playlist.new
		@interface = VLCInterface.new
	end

	def play_next
		raise PlayerException("Queue is empty") if @playlist.empty?
		@interface.add @playlist.pop.uri
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
		play_next if not @playlist.empty?
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
		@playlist.previous
		play_next
	end

	def replay
		@interface.seek 0
		@interface.play
	end
	
	def enqueue(uri, info = {}, options = {})
		media = Media.new(uri, options[:fingerprint], info)
		@playlist.add(media)
		play_next if not is_playing?
	end

	def reevaluate(uri, info = {}, options = {})
		@playlist.queue.each { |media| media.load_info(options[:fingerprint],info) if media.uri == uri }
	end
end