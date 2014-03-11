require 'soundcloud'

module SoundcloudAPI
	def self.create
		Soundcloud.new client_id: '4a4922f76dab4f90e757b13b67e29222'
	end
end