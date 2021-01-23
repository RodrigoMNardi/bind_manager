FROM ruby:2.5

RUN apt-get update
RUN apt-get -y install curl \
    && apt-get -y install nano
RUN apt-get update
RUN apt-get -y install libpq-dev libpq5 postgresql-server-dev-all
RUN apt-get update
RUN apt-get -y install bind9 bind9utils

RUN mkdir /usr/src/bind_manager
WORKDIR /usr/src/bind_manager
COPY Gemfile /usr/src/bind_manager/Gemfile
RUN bundle install --jobs=20 --retry=10
COPY . /usr/src/bind_manager
COPY db/config.yml db/config.yml
CMD rake db:migrate DATABASE=production RAILS_ENV=production
