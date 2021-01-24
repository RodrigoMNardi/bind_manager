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
require 'singleton'
require 'fileutils'
class Config
  include Singleton
  BIND9_FILE = '/etc/bind/named.conf.local'
  def initialize
    unless File.exist? '/etc/bind/zones'
      FileUtils.mkdir '/etc/bind/zones'
    end
  end

  def apply_config
    File.write(BIND9_FILE, '')
    Domain.all.each do |entry|
      File.write(BIND9_FILE, entry.to_bind9, mode: 'a')
      File.write(entry.file, entry.to_file)
    end

    %x(/etc/init.d/bind9 restart)
    %x(rndc reload)
  end

  def remove_config(file)
    FileUtils.rm(file) if File.exist? file

    apply_config
  end
end
