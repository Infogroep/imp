class Media

	def initialize(uri, options={})
		@uri = uri
		@user = options[:user] || " "
		@title = options[:title] || " "
		@author = options[:author] || " "
		@duration = options[:duration] || "--:--"

	end
#downloaden
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

end

