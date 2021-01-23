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
require 'rest-client'
require 'json'

params =
  {
    id: 1,
    zone: 'dallas1.example.com',
    type: 'master',
    file: '/etc/bind/zones/db.dallas1.example.com',
    allow_transfer: '10.128.0.1'
  }
resp   = RestClient.post "0.0.0.0:9292/v1/alter", params.to_json, {content_type: :json, accept: :json}
json = JSON.parse(resp)

puts json.inspect

