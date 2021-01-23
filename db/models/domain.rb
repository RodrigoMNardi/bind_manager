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
class Domain < ActiveRecord::Base
  validates :zone, uniqueness: true, presence: true, length: {maximum: 512}
  validates :mode, presence: true, length: {maximum: 512}
  validates :file, presence: true, length: {maximum: 512}
  validates :allow_transfer, uniqueness: true, presence: true, length: {maximum: 512}

  def to_bind9
    "zone \"#{self.zone}\" {
  type #{self.mode};
  file \"#{self.file}\";
  allow-transfer { #{self.allow_transfer}; };
};
"
  end

  def to_file
    ";
;
;
$TTL    604800
@       IN      SOA     #{self.zone}. admin.#{self.zone}. (
                              2        ; Serial
                         604800        ; Refresh
                          86400        ; Retry
                        2419200        ; Expire
                         604800 )      ; Negative Cache TTL
;
@       IN      NS      #{self.zone}.
@       IN      A       #{self.allow_transfer}
"
  end
end
