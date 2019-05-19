FROM ruby:2.6.3

RUN apt-get update && apt-get install -y build-essential libpq-dev postgresql-client

RUN mkdir /reminder-boy
WORKDIR /reminder-boy
COPY Gemfile /reminder-boy/Gemfile
COPY Gemfile.lock /reminder-boy/Gemfile.lock
RUN bundle install
COPY . /reminder-boy