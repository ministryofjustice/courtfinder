FROM ministryofjustice/ruby:2.1.5-webapp-onbuild

RUN touch /etc/inittab

RUN mkdir -p /etc/service/courtfinder
COPY ./docker/runit/runit-service /etc/service/courtfinder/run
RUN chmod +x /etc/service/courtfinder/run

ENV UNICORN_PORT 3000
EXPOSE $UNICORN_PORT

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]