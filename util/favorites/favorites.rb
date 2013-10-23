require 'rubygems'
require 'active_record'

# This module provides shared resources required for the favorites system.
module Favorites::Favorites
	# Model class for a favorite
	class Favorite < ActiveRecord::Base
		serialize :options

		scope :public, -> { where is_public: true }
		scope :notmine, -> (user) { where("user <> ?", user) }
		scope :private, -> (user) { where user: user }

		# TODO: Validate type
	end
end