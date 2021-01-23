require 'active_record'
require 'active_support'
require 'logger'
require 'singleton'
require 'yaml'

Dir[File.dirname(__FILE__) + '/db/models/*.rb'].each {|model| require model }

class Connector
  include Singleton

  def initialize
    @config                   = YAML::load(IO.read("#{File.dirname(__FILE__)}/database/config.yml"))
    @logger                   = Logger.new(STDOUT)
    @logger.level             = Logger::WARN
    ActiveRecord::Base.logger = @logger
  end

  def verbose
    @logger.level             = Logger::DEBUG
    ActiveRecord::Base.logger = @logger
  end

  def connect2database(db = 'production')
    ActiveRecord::Base.establish_connection(@config[db])
  end
end
