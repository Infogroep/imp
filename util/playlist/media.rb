class Media

	def initialize(uri, info = {})
		@uri = uri
		@info = info
		@info[:user] ||= " "
		@info[:title] ||= " "
		@info[:author] ||= " "
		@info[:duration] ||= "--:--"
	end

	def evaluate(do_fingerprint,info = {})
		fingerprint if do_fingerprint

		info.each { |k,v| @info[k] = v }
	end

	def fingerprint
		fprint = `exiftool -t -n -s #{uri}`
	end

	def method_missing(meth,*args)
		methname = meth.to_s
		if methname.end_with? "="
			@info[methname[0..-2].to_sym] = args[0]
		else
			@info[meth]
		end
	end
end

