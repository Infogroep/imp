require 'securerandom'

##
# This class represents a media item that can be added to the playlist.
class Media
	##
	# A Universally Unique IDentifier that uniquely identifies this
	# media. This ID can be used on the command line to specify this media.
	attr_reader :id

	##
	# The URI to the media file/stream
	attr_reader :uri

	##
	# Allows access to the media info tags
	attr_accessor :info

	##
	# Creates a new Media.
	#
	# Takes a uri which will be played by the Player
	# as well as a boolean which indicates if the file should be
	# fingerprinted (automatical tag lookup). This is useful to disable
	# the fingerprinting system when adding a stream,
	# or to delay the fingerprint until a cached resource has been fully loaded
	#
	# Optionally takes hash with preset tags which will override the
	# fingerprinted tags.
	def initialize(uri, do_fingerprint, info = {})
		@id = SecureRandom.uuid
		@uri = uri
		@info = {}

		load_info(do_fingerprint,info)

		@info["user"] ||= ""
		@info["title"] ||= ""
		@info["artist"] ||= ""
		@info["duration"] ||= "--:--"
	end

	##
	# Optionally performs an automatic fingerprint of the media and
	# then overrides the current tags with the supplied tags.
	def load_info(do_fingerprint, info = {})
		fingerprint if do_fingerprint

		info.each { |k,v| @info[k.downcase] = v }
	end

	##
	# Alternative way to access tag information.
	# Missing methods are interpreted as accessing of tag info
	#
	#   media.title               # get value of :title tag
	#   media.title = "Waterfall" # :title tag set to "Waterfakk"
	def method_missing(meth, *args)
		methname = meth.to_s
		if methname.end_with? "="
			@info[methname[0..-2].downcase] = args[0]
		else
			@info[methname.downcase]
		end
	end

	def to_h
		{
			id: @id,
			uri: @uri,
			info: @info
		}
	end

	private

	def fingerprint
		fprint = `exiftool -t -n -s #{@uri}`
		fprint.split("\n").each do |line|
			k, v = line.split("\t",2)
			@info[k.downcase] = v
		end
	end
end

