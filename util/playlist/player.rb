require_relative 'playlist'
require_relative 'vlcinterface'
require_relative 'media'

##
# This exception is thrown by the Player on illegal operations.
# Usually this means you are trying to play an empty queue or
# similar mistakes.
class PlayerError < StandardError
end

##
# This class is the main interface through which you can
# enqueue media items and play them, as well as control the media player.
class Player
	##
	# Creates a new media player
	def initialize()
		@playlist = Playlist.new
		@interface = VLCInterface.new
	end

	##
	# Plays the current media in the playlist queue.
	# Raises a PlayerError if the queue is empty.
	def play_current
		raise PlayerError("Queue is empty") if @playlist.empty?
		@interface.add @playlist.current.uri
	end

	##
	# Stops playback
	def stop
		@interface.stop
	end

	##
	# Pauses playback
	def pause
		@interface.pause
	end

	##
	# Returns a Boolean indicating if the media player is playing
	def is_playing?
		@interface.is_playing?
	end

	##
	# Get the current position in the media in seconds
	def get_time
		@interface.get_time
	end

	##
	# Get the length of the current media as known by the internal media player
	def get_length
		@interface.get_length
	end

	##
	# Seek to a certain position in the current media
	def seek(seconds) 
		@interface.seek seconds
	end

	##
	# Skips the current song. Stops playback if the playlist's queue is empty.
	def skip
		play_current if @playlist.next
	end

	##
	# Stops playback and clears the playlist's queue
	def flush
		stop
		@playlist.flush
	end

	##
	# Shuffles and shifts the requested item to the front.
	#
	# +item+ is the UUID representing the item
	def magic_shuffle(item)
		@playlist.magic_shuffle(item)
	end

	##
	# Shuffles the playlist's queue
	def shuffle
		@playlist.shuffle
	end

	##
	# Removes an item from the playlist
	#
	# +item+ is the UUID representing the item
	def dequeue(item)
		@playlist.remove(item)
	end

	##
	# Returns the playlist's queue
	def playlist
		@playlist.queue
	end

	##
	# Returns the playlist's history
	def history
		@playlist.history
	end

	##
	# Plays the previous song
	def previous
		play_current if @playlist.previous
	end

	##
	# Plays the current song from the start
	def replay
		play_current
	end

	##
	# Adds a new media to the queue
	#
	# +uri+ is a media URI that can be played by the media player.
	# +info+ is a hash of media tag overrides.
	# 
	# Possible options are:
	# [fingerprint] Boolean that decides if tags should be determined through
	#               fingerprinting. Defaults to +false+.
	#
	# Returns the media ID.
	def enqueue(uri, info = {}, options = {})
		media = Media.new(uri, options[:fingerprint], info)
		@playlist.add(media)
		play_current if not is_playing?
		media.id
	end

	##
	# Reloads media info.
	#
	# +id+ is the media ID.
	# +info+ is a hash of media tag overrides.
	# 
	# Possible options are:
	# [fingerprint] Boolean that decides if tags should be determined through
	#               fingerprinting. Defaults to +false+.
	#
	# Raises a PlayerError if the media can't be found
	def reevaluate(id, info = {}, options = {})
		media = @playlist.find_media_by_id(id)
		raise PlayerError("Can't find requested media") if not media

		media.load_info(options[:fingerprint],info)
	end
end