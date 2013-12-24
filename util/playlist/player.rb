require_relative 'playlist'
require_relative 'vlcinterface'
require_relative 'media'
require 'json'

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
	def initialize
		@mutex = Mutex.new

		@playlist = Playlist.new
		@interface = VLCInterface.new lambda &method(:on_media_end)
	end

	##
	# Plays the current media in the playlist queue.
	# Raises a PlayerError if the queue is empty.
	def play_current
		synchronized do
			puts "Playing"
			raise PlayerError, "Queue is empty" if @playlist.queue.empty?
			@interface.add @playlist.current.uri
		end
	end

	##
	# Stops playback
	def stop
		synchronized do
			@interface.stop
		end
	end

	##
	# Pauses playback
	def pause
		synchronized do
			@interface.pause
		end
	end

	##
	# Returns a Boolean indicating if the media player is playing
	def is_playing?
		synchronized do
			@interface.is_playing?
		end
	end

	##
	# Get the current position in the media in seconds
	def get_time
		synchronized do
			@interface.get_time
		end
	end

	##
	# Get the length of the current media as known by the internal media player
	def get_length
		synchronized do
			@interface.get_length
		end
	end

	##
	# Seek to a certain position in the current media
	def seek(seconds) 
		synchronized do
			@interface.seek seconds
		end
	end

	##
	# Plays the next song. Stops playback if the playlist's queue is empty.
	def next
		synchronized do
			if @playlist.next
				play_current
			else
				stop
			end
		end
	end

	##
	# Stops playback and clears the playlist's queue
	def flush
		synchronized do
			stop
			@playlist.flush
		end
	end

	##
	# Shuffles and shifts the requested item to the front.
	#
	# +id+ is the UUID representing the item
	def magic_shuffle(id)
		synchronized do
			@playlist.magic_shuffle(@playlist.find_media_by_id(id))
		end
	end

	##
	# Shuffles the playlist's queue
	def shuffle
		synchronized do
			@playlist.shuffle
		end
	end

	##
	# Removes an item from the playlist
	#
	# +item+ is the UUID representing the item
	def dequeue(item)
		synchronized do
			@playlist.remove(item)
		end
	end

	##
	# Returns the playlist's queue
	def playlist
		synchronized do
			JSON.generate(@playlist.queue.map { |m| m.to_h })
		end
	end

	##
	# Returns the playlist's history
	def history
		synchronized do
			JSON.generate(@playlist.history.map { |m| m.to_h })
		end
	end

	##
	# Plays the previous song. If there is no previous song, restarts current song.
	def previous
		synchronized do
			if @playlist.previous
				play_current 
			else
				replay
			end
		end
	end

	##
	# Plays the current song from the start
	def replay
		synchronized do
			play_current
		end
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
		synchronized do
			media = Media.new(uri, options[:fingerprint], options[:attached_files], info)
			@playlist.add(media)
			puts "Geadd"
			play_current if not is_playing?
			media.id
		end
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
		synchronized do
			media = @playlist.find_media_by_id(id)
			raise PlayerError, "Can't find requested media" if not media

			media.load_info(options[:fingerprint],info)
		end
	end

	def attach_files(id, files)
		synchronized do
			media = @playlist.find_media_by_id(id)
			raise PlayerError, "Can't find requested media" if not media

			media.attach_files(files)
		end
	end

	def find_media(id)
		synchronized do
			media = @playlist.find_media_by_id(id)
			raise PlayerError, "Can't find requested media" if not media
			JSON.generate(media.to_h)
		end
	end

	def to_front(id)
		synchronized do
			@playlist.move_to_front(@playlist.find_media_by_id(id))
		end
	end

	private

	##
	# This event is called when the media player interface stops playing
	def on_media_end
		@mutex.synchronize do
			puts "Media ended"
			self.next
		end
	end

	def synchronized
		if @mutex.owned?
			yield
		else
			@mutex.synchronize do
				yield
			end
		end
	end
end