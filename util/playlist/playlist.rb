##
# This class represents a playlist.
# It keeps queue of media to be played and a history of
# media that have already been played.
class Playlist
	##
	# Creates a new playlist.
	def initialize()
		@queue = Array.new
		@history = Array.new
	end

	##
	# Adds a Media to the queue
	def add(media)
		@queue<<media
	end

	##
	# Returns the current media
	def current
		@queue.first
	end

	##
	# Moves to the next media.
	#
	# Returns the next media
	def next
		return nil if @queue.empty?
		
		@history<<@queue.first
		@queue.shift
		@queue.first
	end
	
	##
	# Moves to the previous media
	def previous
		return nil if @history.empty?

		prev = @history.pop
		@queue.insert(0, prev)
		prev
	end

	##
	# Shuffles the queue
	def shuffle
		@queue.shuffle
	end

	##
	# Shuffles and shifts the requested media to the front.
	#
	# +media+ is a Media
	def magic_shuffle(media)
		shuffle
		move_to_front(media)
	end

	##
	# Shifts the requested media to the front.
	#
	# +media+ is a Media
	def move_to_front(media)
		remove(media)
		@queue.insert(0, media)
	end

	##
	# Removes a Media from the queue
	def remove(media)
		@queue.delete(media)
	end

	##
	# Clears the queue
	def flush
		@queue.clear
	end

	##
	# Returns the queue as an array
	def queue
		@queue
	end

	##
	# Retursn the history as an array
	def history
		@history
	end

	##
	# Find a Media in the queue or history using its UUID
	def find_media_by_id(id)
		@queue.find { |m| m.id == id } or @history.find { |m| m.id == id }
	end
end
