

class Playlist
	def initialize()
		@queue = Array.new
		@history = Array.new
	end

	def add(item)
		@queue<<item
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

	def magic_shuffle(item)
		shuffle
		move_to_front(item)
	end

	def move_to_front(item)
		remove(item)
		@queue.insert(0, item)
	end

	def remove(item)
		@queue.delete(item)
	end

	def flush
		@queue.clear
	end

	def show
		@queue
	end

	def history
		@history
	end
end
