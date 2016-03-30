FROM ministryofjustice/ruby:2-webapp-onbuild

# RUN apt-get update && apt-get install -y qt4-dev-tools libqt4-dev libqt4-core libqt4-gui nodejs
# yes, we need python dependencies on the rails app, because
# the db export script is written in python. 
RUN apt-get update && apt-get install -y python-setuptools python-dev 
RUN easy_install pip
RUN pip install -r /usr/src/app/script/requirements.txt

RUN touch /etc/inittab

ENV UNICORN_PORT 3000
EXPOSE $UNICORN_PORT

COPY run.sh /run.sh
RUN chmod +x /run.sh

## Django setup
ENV DJANGO_SETTINGS_MODULE courtfinder.settings.production
## Rails setup
ENV RAILS_ENV production
# Precompile assets in here to setup digest
RUN RAILS_ENV=production bundle exec rake assets:clean assets:precompile

CMD /run.sh

