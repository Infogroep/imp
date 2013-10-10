import sys
import re

class Router:
	routed = False

	def match(self,rule,to,options = {}):
		realargs = sys.argv[3:]

		incoming_method = sys.argv[1].lower()

		if options["via"] != "all" and options["via"] != incoming_method and not incoming_method in options["via"]:
			return
		if len(realargs) != len(rule):
			return

		bindings = self.match_rule(rule,realargs,options)
		if bindings:
			self.routed = True
			to(bindings)

	def __getattr__(self,attr):
		return lambda rule,to,options = {}: self.special_match(attr,rule,to,options)

	def special_match(self,attr,rule,to,options = {}):
		options["via"] = attr
		self.match(rule,to,options)

	def is_routed():
		self.routed

	def match_rule(self,rule,realargs,options = {}):
		bindings = {}
		for (rule_el,realarg) in zip(rule,realargs):
			if rule_el[0] == ":":
				if rule_el in options and not re.compile(options[rule_el]).match(realarg):
					return False
				bindings[rule_el] = realarg
			elif type(rule_el) == str:
				if rule_el != realarg:
					return False
			else:
				raise "Illegal rule for router match: #{rule}"
		return bindings

	def finalize(self):
		if not self.routed:
			raise BaseException("Couldn't find a route")
