require 'securerandom'

##
# This class represents a media item that can be added to the playlist.
class Media
	##
	# A Universally Unique IDentifier that uniquely identifies this
	# media. This ID can be used on the command line to specify this media.
	attr_reader :id

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

		@info[:user] ||= ""
		@info[:title] ||= ""
		@info[:author] ||= ""
		@info[:duration] ||= "--:--"
	end

	##
	# Optionally performs an automatic fingerprint of the media and
	# then overrides the current tags with the supplied tags.
	def load_info(do_fingerprint, info = {})
		fingerprint if do_fingerprint

		info.each { |k,v| @info[k] = v }
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
			@info[methname[0..-2].to_sym] = args[0]
		else
			@info[meth]
		end
	end

	private

	def fingerprint
		fprint = `exiftool -t -n -s #{uri}`
		fprint.lines.each do |line|
			[k, v] = line.split("\t",2)
			@info[k] = v
		end
	end
end

