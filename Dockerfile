FROM nginx:stable
MAINTAINER Dave Bauman baumandm@gmail.com

# Update the repository
RUN apt-get update

# Install dependencies
RUN apt-get install -y bzip2 curl git nano supervisor wget gnupg2
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add Cyclotron Nginx configuration file
# TODO: Migrate to /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/cyclotron.conf

# Launch Nginx in non-daemon mode
#RUN echo "daemon off;" >> /etc/nginx/nginx.conf

## Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - ; apt-get install -y nodejs

RUN npm install -g gulp phantomjs-prebuilt casperjs

## Clone and build Cyclotron
RUN git clone https://github.com/ExpediaInceCommercePlatform/cyclotron.git /opt/cyclotron

RUN cd /opt/cyclotron/cyclotron-svc/; npm install
RUN cd /opt/cyclotron/cyclotron-site/; npm install; gulp build

# Add Cyclotron configuration files
COPY cyclotron-site.config.js /opt/cyclotron/cyclotron-site/_public/js/conf/configService.js
COPY cyclotron-svc.config.js /opt/cyclotron/cyclotron-svc/config/config.js

# Add Supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/cyclotron-svc /var/log/supervisor

EXPOSE 777 8077

# Launch supervisor
CMD ["/usr/bin/supervisord"]
