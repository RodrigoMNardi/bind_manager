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
FROM ruby:2.5

RUN apt-get update
RUN apt-get -y install curl \
    && apt-get -y install nano
RUN apt-get update
RUN apt-get -y install libpq-dev libpq5 postgresql-server-dev-all
RUN apt-get update
RUN apt-get -y install bind9 bind9utils libnet-nslookup-perl

RUN mkdir /usr/src/bind_manager
WORKDIR /usr/src/bind_manager
COPY Gemfile /usr/src/bind_manager/Gemfile
RUN bundle install --jobs=20 --retry=10
COPY . /usr/src/bind_manager
COPY db/config.yml db/config.yml
CMD rake db:migrate DATABASE=production RAILS_ENV=production
