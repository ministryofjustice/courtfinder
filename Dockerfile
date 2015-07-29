FROM ministryofjustice/ruby:2

RUN apt-get update && apt-get install -y qt4-dev-tools libqt4-dev libqt4-core libqt4-gui

RUN mkdir -p /usr/src/app
RUN bundle config --global

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

WORKDIR /usr/src/app
RUN bundle install

COPY . /usr/src/app

RUN touch /etc/inittab

RUN mkdir -p /etc/service/courtfinder
COPY ./docker/runit/runit-service /etc/service/courtfinder/run
RUN chmod +x /etc/service/courtfinder/run

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]