module Routing
	class Router
		def match(rule = [],options = {})
			realargs = ARGV[2..-1]

			incoming_method = ARGV[0].downcase.to_sym
			return if options[:via] != :all and options[:via] != incoming_method and not options[:via].include? incoming_method
			return if realargs.size() != rule.size()

			bindings = match_rule(rule,realargs,options)
			if bindings
				@routed = true
				yield bindings
			end
		end

		def method_missing(methId,rule = [],options = {})
			options[:via] = [methId]
			match(rule,options) { |b| yield b }
		end

		def routed?
			@routed
		end

		private

		def match_rule(rule,realargs,options = {})
			bindings = {}
			rule.zip(realargs).each do |rule_el,realarg|
				case rule_el
				when Symbol
					return false if not options[rule_el].nil? and not realarg =~ options[rule_el]
					bindings[rule_el] = realarg
				when String
					return false if rule_el != realarg
				else
					raise "Illegal rule for router match: #{rule}"
				end
			end
			return bindings
		end
	end

	def self.route
		router = Router.new
		yield router
		raise "Couldn't find a route" if not router.routed?
	end
end