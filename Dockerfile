FROM node:10.16.0 as node
FROM ruby:2.6.3

RUN apt-get update && apt-get install -y build-essential libpq-dev postgresql-client

ENV YARN_VERSION 1.16.0

COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/

RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

RUN mkdir /reminder-boy
WORKDIR /reminder-boy
COPY Gemfile /reminder-boy/Gemfile
COPY Gemfile.lock /reminder-boy/Gemfile.lock
RUN bundle install
COPY . /reminder-boy

ARG RAILS_ENV=development
RUN if [ "$RAILS_ENV" = "production" ]; then SECRET_KEY_BASE=$(rails secret) bundle exec rails assets:precompile; fi
