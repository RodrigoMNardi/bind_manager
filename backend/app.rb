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
require 'roda'
require 'json'

class BindApi < Roda
  plugin :json, classes: [Array, Hash], content_type: 'application/json'
  plugin :json_parser
  plugin :all_verbs
  plugin :halt

  route do |r|
    r.on 'v1' do
      r.post 'create' do
        params = filter(r)
        return params if params.key? :status

        domain = Domain.create(params)
        if domain.valid?
          Config.instance.apply_config
          {id: domain.id, status: true, message: 'Domain created successfully'}
        else
          {status: false, message: 'Failed to create a domain'}
        end
      end

      r.post 'alter' do
        params      = filter(r)
        return params if params.key? :status
        return {status: false, message: 'Invalid ID'} unless r.params.key? 'id' or r.params['id'].empty?

        domain = Domain.where(id: r.params['id'].to_i).first
        return {status: false, message: 'Domain not found'} if domain.nil?

        if domain.update(params)
          Config.instance.apply_config
          {id: domain.id, status: true, message: 'Domain updated'}
        else
          {id: domain.id, status: false, message: 'Failed to update domain'}
        end
      end

      r.post 'delete' do
        return {status: false, message: ''} unless r.params.key? 'id' or r.params['id'].empty?

        domain = Domain.where(id: r.params['id'].to_i).first
        return {status: false, message: 'Domain not found'} if domain.nil?

        file  = domain.file
        if domain.destroy
          Config.instance.remove_config(file)
          {id: domain.id, status: true, message: 'Domain deleted'}
        else
          {id: domain.id, status: false, message: 'Failed to delete domain'}
        end
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
      zone:           z.params['zone'],
      mode:           z.params['type'] || 'master',
      file:           z.params['file'] || "/etc/bind/zones/#{z.params['zone']}",
      allow_transfer: z.params['allow_transfer']
    }
  end
end


