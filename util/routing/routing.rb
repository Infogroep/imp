##
# This module provides a simple way to decide program action
# based on the command line parameters. This is particularly
# useful for scripts that will be called by the server,
# as it allows simple processing of the URI.
#
module Routing
	##
	# The Router class is the main brain of the routing module.
	#
	class Router
		##
		# Creates a new router that will route based on the +argv+ provided.
		# The default +argv+ is ARGV without the first parameter,
		# which in server scripts corresponds to the HTTP method followed
		# by the remaining URL path.
		#
		def initialize(argv = nil)
			argv ||= ARGV.drop(1)

			raise "Not enough arguments" if argv.empty?
			@argv = argv
		end

		##
		# Attempts to match a rule. A rule consists of an array of strings or symbols.
		# These will be matched one by one respectively to the arguments provided during
		# the router's initialization.
		#
		# Arguments can be captured into a hashtable which is sent as a parameter to the
		# associated block.
		#
		# * A String will be matched verbatim but case insensitive to
		#   their respective argument.
		# * A Regexp will be matched according to regexp rules.
		# * Symbols represent a capture, and will cause the argument to be
		#   pulled into the bindings hash. Captures can still be constrained
		#   by providing a Regexp that needs to be matched with the capture's name
		#   in the options.
		#
		# The provided block will be executed if the rule matches.
		#
		#   # get playlist <id>
		#   r.match ["get","playlist",:playlist_id] { |b| show_pl b[:playlist_id] }
		#   
		#   # set <numeric id>
		#   r.match ["set",:id], id: /[0-9]+/ { |b| set_id b[:id].to_i }
		#
		#   # help/info
		#   r.match [["help","info"]] { show_info }
		#   
		#   # add <id> to <username>
		#   r.match ["add",:id,"to",:username], id: /[0-9]+/, username: /[a-z]+/ do
		#     add_id_to_username b[:id].to_i, b[:username]
		#   end
		#
		# Generally you will want to use the helper functions provided by the
		# method_missing implementation as it allows for a cleaner notation for standard
		# queries.
		#
		def match(via,rule = [],options = {})
			realargs = @argv[1..-1]

			return if realargs.size() != rule.size()

			bindings = match_rule(rule,realargs,options)
			if bindings
				@routed = true
				yield bindings
			end
		end

		##
		# Provides helper methods for the match function.
		#
		# When an arbitrary method is called on the Router object
		# it is processed as a match where the first rule element is
		# the method name as a string.
		#
		# This allows for a shorter and clearer notation for typical usage,
		# especially when handling HTTP requests in server scripts,
		# where it shows a clear difference between the HTTP method and
		# the URL parts.
		#
		#   # get playlist <id>
		#   r.get ["playlist",:playlist_id] { |b| show_pl b[:playlist_id] }
		#   
		#   # set <numeric id>
		#   r.set [:id], id: /[0-9]+/ { |b| set_id b[:id].to_i }
		#
		#   # help
		#   r.help { show_help }
		#   
		#   # add <id> to <username>
		#   r.add [:id,"to",:username],	id: /[0-9]+/, username: /[a-z]+/ do
		#     add_id_to_username b[:id].to_i, b[:username]
		#   end
		#
		def method_missing(meth,rule = [],options = {})
			match([meth.to_s] + rule,options) { |b| yield b }
		end

		##
		# Returns true if the Router has found a route.
		#
		def routed?
			@routed
		end

		private

		def match_rule_element(rule_el,realarg,bindings)
			case rule_el

			# If the element is a Symbol, add to bindings and match
			# the potential RegExp in the options
			when Symbol
				bindings[rule_el] = realarg
				options[rule_el].nil? or realarg =~ options[rule_el]

			# If the element is a RegExp, match the RegExp
			when Regexp
				rule_el =~ realarg

			# If the element is a String, verbatim case insensitive check
			when String
				rule_el.casecmp(realarg) == 0

			# If the element is an Array, check if any of its elements match
			when Array
				# Relies on the behaviour that +any?+ returns at the first +true+ for
				# the correct setting of the bindings.
				# This is not documented behaviour, so if this suddenly breaks, check
				# this condition.
				rule_el.any? { |rule_e| match_rule_element rule_e, realarg, bindings }

			# Else this is not a correct rule
			else
				raise "Illegal rule for router match: #{rule}"
			end
		end

		def match_rule(rule,realargs,options = {})
			bindings = {}
			rule.zip(realargs).each do |rule_el,realarg|
				if not match_rule_element return false
			end
			return bindings
		end
	end

	##
	# Prepares a router and passes it as an argument to the attached block.
	# Raises an error if the Router did not find a route after the execution
	# of the block.
	#
	#   Routing::route do |r|
	#     r.put { put_collection }
	#     r.put [:id] { |b| put_item b[:id] }
	#   end
	#
	def self.route(argv = nil)
		router = Router.new argv
		yield router
		raise "Couldn't find a route" if not router.routed?
	end
end