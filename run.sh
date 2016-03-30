#!/bin/bash
cd /usr/src/app
case ${DOCKER_STATE} in
migrate)
    echo "running migrate"
    bundle exec rake db:migrate
    ;;
seed)
    echo "running seed"
    bundle exec rake db:migrate
    bundle exec rake db:seed
    ;;
vagrant)
    echo "running seed"
    bundle exec rake db:create
    bundle exec rake db:seed
    bundle exec rake db:migrate
    ;;
create)
    echo "running seed"
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed
    bundle exec rake import:all
    ;;
esac
bundle exec rails s -b 0.0.0.0
