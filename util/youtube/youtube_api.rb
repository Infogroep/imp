require 'rubygems'
require 'google/api_client'

class YoutubeAPI < Google::APIClient
	def initialize
		super key: "AIzaSyDkktCySGJkQFlWxqpOwUOEE_6gHlPg4qA", authorization: nil
	end
end