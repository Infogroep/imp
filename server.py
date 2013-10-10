from twisted.internet import reactor, protocol
from twisted.web import server
from twisted.spread import pb
from twisted.web.resource import Resource
from twisted.python import log
from os import path
import subprocess

class Script(Resource):
	isLeaf = True

	def find_suitable_script(self, patharray):
		for i in reversed(range(len(patharray) + 1)):
			potential_path_array = ['scripts'] + patharray[:i]
			potential_path = apply(path.join, potential_path_array)

			if not path.exists(potential_path):
				continue

			if path.isfile(potential_path):
				return potential_path

			if path.isdir(potential_path):
				main_path = apply(path.join, potential_path_array + ['main'])

				if not path.exists(main_path):
					continue

				if path.isfile(main_path):
					return main_path

		raise BaseException("Unknown script")

	def render(self, request):
		the_script = self.find_suitable_script(request.postpath)
		content_type = request.getHeader("Content-Type") or "text/plain"
		
		p = ScriptProtocol(request)
		reactor.spawnProcess(p, 
		                    the_script,
		                    [the_script] + [request.method,content_type])
		return server.NOT_DONE_YET

class ScriptProtocol(protocol.ProcessProtocol, pb.Viewable):
    errortext = ''

    def view_resumeProducing(self, issuer):
        self.resumeProducing()

    def view_pauseProducing(self, issuer):
        self.pauseProducing()

    def view_stopProducing(self, issuer):
        self.stopProducing()

    def resumeProducing(self):
        self.transport.resumeProducing()

    def pauseProducing(self):
        self.transport.pauseProducing()

    def stopProducing(self):
        self.transport.loseConnection()

    def __init__(self, request):
        self.request = request

    def connectionMade(self):
        self.request.registerProducer(self, 1)
        self.request.content.seek(0, 0)
        content = self.request.content.read()
        if content:
            self.transport.write(content)
        self.transport.closeStdin()

    def errReceived(self, error):
        self.errortext = self.errortext + error

    def outReceived(self, output):
        self.request.write(output)

    def processEnded(self, reason):
        if reason.value.exitCode != 0:
            log.msg("Script %s exited with exit code %s" %
                    (self.request.uri, reason.value.exitCode))
        if self.errortext:
            log.msg("Errors from script %s: %s" % (self.request.uri, self.errortext))
        self.request.unregisterProducer()
        self.request.finish()

root = Script()
factory = server.Site(root)
reactor.listenTCP(8880, factory)
reactor.run()
