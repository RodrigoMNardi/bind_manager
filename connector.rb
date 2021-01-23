#  Bind Manager - DNS control system using BIND9, where it is possible to create, change and delete through a REST API
#  Copyright (C) 2021  Rodrigo Mello Nardi
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
require 'active_record'
require 'active_support'
require 'logger'
require 'singleton'
require 'yaml'

Dir[File.dirname(__FILE__) + '/db/models/*.rb'].each {|model| require model }

class Connector
  include Singleton

  def initialize
    @config                   = YAML::load(IO.read("#{File.dirname(__FILE__)}/db/config.yml"))
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
