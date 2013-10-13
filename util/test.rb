class A
	def method_missing(meth, *args)
		puts meth.to_s
	end
end

a = A.new
a.hello
a.hello = 5
