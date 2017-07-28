FROM mongo:latest
MAINTAINER <knutole@mapic.io>

# add start scripts
ADD init_mongo.js /init_mongo.js
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# start
CMD /docker-entrypoint.sh