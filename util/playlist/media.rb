class Media

	def initialize(uri, options={})
		@uri = uri
		@user = options[:user] || " "
		@title = options[:title] || " "
		@author = options[:author] || " "
		@duration = options[:duration] || "--:--"

	end

	def uri
		@uri
	end

	def user
		@user
	end

	def title
		@title
	end

	def author
		@author
	end

	def duration
		@duration
	end

	def evaluate(options)
		fingerprint if options[:fingerprint]

		@user = options[:user] if options[:user]
		@title = options[:title] if options[:title]
		@author = options[:author] if options[:author]
		@duration = options[:duration] if options[:duration]
	end

	def fingerprint
		fprint = `exiftool -t -n -s #{uri}`
	end
end

