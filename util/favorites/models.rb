require 'rubygems'
require 'active_record'

# This module provides shared resources required for the favorites system.
module Favorites
	module Models
		# Model class for a favorite
		class Favorite < ActiveRecord::Base
			serialize :options

			has_many :keywords, dependent: :destroy
			validates_presence_of :name
			validates_presence_of :options
			validates_presence_of :plugin
			validates_inclusion_of :is_public, :in => [true,false]
			validates_format_of :plugin, with: /\A[a-zA-Z0-9-]+\z/

			scope :public, -> { where is_public: true }
			scope :notmine, -> (user) { where("user <> ?", user) }
			scope :private, -> (user) { where user: user }

			before_save :default_values

			def default_values
				self.user ||= ENV["IMP_REQUESTING_USER"]
				self.keywords ||= []
			end
		end

		# Model class for a keyword
		class Keyword < ActiveRecord::Base
			belongs_to :favorite

			validates_uniqueness_of :keyword
			validates_presence_of :keyword
		end
	end
end