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
require "roda"

class BindApi < Roda
  plugin :json, classes: [Array, Hash, Sequel::Model], content_type: 'application/json'
  plugin :json_parser
  plugin :all_verbs
  plugin :halt

  route do |r|
    r.on 'v1' do
      r.post 'create' do
        params = filter(r)
        return params if params.key? :status


      end

      r.post 'alter' do

      end

      r.post 'delete' do

      end
    end
  end

  def filter(z)
    if z.params.key? 'zone' and z.params['zone'].empty?
      return {status: false, message: 'Invalid zone'}
    end

    if z.params.key? 'allow-transfer' and z.params['zone'].empty?
      return {status: false, message: 'Invalid allow-transfer'}
    end
    {
      zone: z.params['zone'],
      type: z.params['type'] || 'master',
      file: z.params['file'] || "/etc/bind/zones/#{z.params['zone']}",
      ip: z.params['allow-transfer']
    }
  end
end


