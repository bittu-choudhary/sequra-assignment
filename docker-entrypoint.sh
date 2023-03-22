#!/bin/sh
set -e

if [ "$1" = 'development' ]; then

  # bundle exec rails db:drop db:create && bundle exec rails db:migrate && bundle exec rails db:seed
  RAILS_ENV=development bin/rails db:create
  RAILS_ENV=development bundle exec rails db:migrate
  RAILS_ENV=development bundle exec rails db:seed
  exit
fi