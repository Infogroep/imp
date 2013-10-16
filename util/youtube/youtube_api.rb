require 'rubygems'
require 'google/api_client'

class YoutubeAPI < Google::APIClient
	def initialize
		super application_name: "imp",
		      application_version: "0.1",
		      key: "AIzaSyDkktCySGJkQFlWxqpOwUOEE_6gHlPg4qA",
		      authorization: nil
	end
end