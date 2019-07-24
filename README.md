# Reminder Boy

[![CircleCI](https://circleci.com/gh/tanaken0515/reminder-boy/tree/master.svg?style=svg)](https://circleci.com/gh/tanaken0515/reminder-boy/tree/master)

## Get start

```sh
$ git clone git@github.com:tanaken0515/reminder-boy.git
$ cp .env.sample .env
$ vi .env
$ docker-compose build
$ docker-compose run --rm web bundle exec rails db:create db:migrate
```
