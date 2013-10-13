class Playlist
	def initialize()
		@queue = Array.new
		@history = Array.new
	end

	def add(media)
		@queue<<media
	end

	def pop
		@history<<@queue.first
		@queue.shift
	end
	
	def previous
		@queue.insert(0, @history.pop)
	end

	def shuffle
		@queue.shuffle
	end

	def magic_shuffle(media)
		shuffle
		move_to_front(media)
	end

	def move_to_front(media)
		remove(media)
		@queue.insert(0, media)
	end

	def remove(media)
		@queue.delete(media)
	end

	def flush
		@queue.clear
	end

	def queue
		@queue
	end

	def history
		@history
	end
end
