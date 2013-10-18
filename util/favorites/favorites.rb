require 'rubygems'
require 'active_record'

module Favorites::Favorites
	class Favorite < ActiveRecord::Base
		serialize :options

		validates_uniqueness_of :name, scope: :user, conditions: -> { where is_public: false }
		validates_uniqueness_of :name, conditions: -> { where is_public: true }

		scope :public, -> { where is_public: true }
		scope :public_from_others, -> (user) { where("user <> ?", user) }
		scope :private, -> (user) { where user: user }
	end
end