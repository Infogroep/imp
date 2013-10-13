module Routing
	class Router
		def initialize(argv)
			raise "Not enough arguments" if argv.empty?
			@argv = argv
		end

		def match(rule = [],options = {})
			realargs = @argv[1..-1]

			incoming_method = @argv[0].downcase.to_sym
			options[:via] = options[:via].map{ |method| method.downcase.to_sym }
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

	def self.route(argv = nil)
		argv ||= ARGV.drop(1)
		router = Router.new argv
		yield router
		raise "Couldn't find a route" if not router.routed?
	end
end