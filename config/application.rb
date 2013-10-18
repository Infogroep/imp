require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'

module Imp
	class Application < Rails::Application
		config.autoload_paths << "#{config.root}/util"
	end
end
