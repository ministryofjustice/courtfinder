#!/bin/bash
#
#The script will:
#  pull down a postgresql container and run it
#  build a container for the django code, based on the Dockerfile in the repo (so it resembles prod)
#  link the containers
#  runs a django migrate
#  mount the work dir inside the container so one can use his favourite IDE to change code that's running inside the container
#
#Note: django will pick up on the code changes and restart itself automatically


set -eu
GREEN='\n\e[1;32m%-6s\e[m\n'
RED='\n\e[1;31m%-6s\e[m\n'

run_postgres_container() {
  printf $GREEN "postgres container not found or killed, cleaning up and starting a new one."
  docker rm courtfinder-db 2>/dev/null || :
  docker run -p 5432:5432 --name courtfinder-db -e POSTGRES_PASSWORD=courtfinder -e POSTGRES_USER=courtfinder -d postgres
}


build_app_container() {
  printf $GREEN "Building the docker container, this might take a few minutes... " && sleep 2
  docker build -t courtfinder-dev .
}


manage() {
  printf $GREEN "Running management cmd $1"
  docker rm courtfinder 2>/dev/null || :
  docker run --rm -ti -p 8000:8000 -v $(pwd):/srv/courtfinder \
      --name courtfinder \
      --link courtfinder-db:postgres \
      -e "DB_PASSWORD=courtfinder" \
      -e "DB_USER=courtfinder" \
      -e "OS_FTP_USERNAME=${OS_FTP_USERNAME:-anonymous}" \
      -e "OS_FTP_PASSWORD=${OS_FTP_PASSWORD:-anonymous@}" \
      -e "DJANGO_DEBUG=${DJANGO_DEBUG:-True}" \
      -e "DJANGO_ALLOWED_HOSTS=${DJANGO_ALLOWED_HOSTS:-localhost}" \
      -e "DB_NAME=courtfinder" \
      -e "DB_USERNAME=courtfinder" \
      -e "DB_PASSWORD=courtfinder" \
      -e "DB_HOST=postgres" \
      -e "DB_PORT=5432" \
      courtfinder-dev bundle exec $1
}


printf $GREEN "Looking for an existing postgres container..."
docker inspect courtfinder-db|grep '"Running": true' 2>&1>/dev/null || run_postgres_container

# Give the postgres container a chance to start
sleep 5

build_app_container || printf $RED "Failed to build container"

manage "rake db:migrate db:seed" || printf $RED "Failed to execute migration"
manage "rails s -b 0.0.0.0 -p 8000"
