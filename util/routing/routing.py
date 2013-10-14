import sys
import re

class Router:
	routed = False

	def __init__(self,argv = sys.argv[2:]):
		self.argv = argv

	def match(self,rule,to,options = {}):
		if len(self.argv) != len(rule):
			return

		bindings = self.match_rule(rule,self.argv,options)
		if bindings:
			self.routed = True
			to(bindings)

	def __getattr__(self,attr):
		return lambda rule,to,options = {}: self.special_match(attr,rule,to,options)

	def special_match(self,attr,rule,to,options = {}):
		self.match([attr] + rule,to,options)

	def is_routed(self):
		return self.routed

	def match_rule_element(self,rule_el,realarg,bindings,options):
		if rule_el[0] == ":":
			bindings[rule_el] = realarg
			return not rule_el in options or re.compile(options[rule_el]).match(realarg)
		elif type(rule_el) == str:
			return rule_el.lower() == realarg.lower()
		elif type(rule_el) == list:
			for el in rule_el:
				if self.match_rule_element(el,realarg,bindings,options):
					return True
			return False
		else:
			raise "Illegal rule for router match: #{rule}"

	def match_rule(self,rule,realargs,options):
		bindings = {}
		for (rule_el,realarg) in zip(rule,realargs):
			if not self.match_rule_element(rule_el,realarg,bindings,options):
				return False
		return bindings

	def finalize(self):
		if not self.routed:
			raise BaseException("Couldn't find a route")
