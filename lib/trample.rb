gem 'sevenwire-rest-client'
require 'log4r'
require 'rest_client'
require 'hpricot'

module Trample
  autoload :Configuration, File.dirname(__FILE__) + "/trample/configuration"
  autoload :Page, File.dirname(__FILE__) + "/trample/page"
  autoload :Session, File.dirname(__FILE__) + "/trample/session"
  autoload :Runner, File.dirname(__FILE__) + "/trample/runner"
  autoload :Cli, File.dirname(__FILE__) + "/trample/cli"
  autoload :Logging, File.dirname(__FILE__) + "/trample/logging"
  autoload :Timer, File.dirname(__FILE__) + "/trample/timer"
  autoload :BaseHandler, File.dirname(__FILE__) + "/trample/handler/base_handler"
  autoload :RailsHandler, File.dirname(__FILE__) + "/trample/handler/rails_handler"

  class << self
    attr_reader :current_configuration

    def configure(&block)
      @current_configuration = Configuration.new(&block)
    end
  end
end

