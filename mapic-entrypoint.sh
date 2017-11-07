#!/bin/bash

# MongoDB needs to be inited with auth settings
# ---------------------------------------------
# 1: check if inited
# 1.1: start mongodb without auth
# 1.2: add admin/user with pass
# 2: restart mongo with auth config
echo "MongoDB start script: mapic-entrypoint.sh"

# config path (never changes)
CONFIGFILE=/mapic/mongod.conf

function abort() {
	echo $1
	exit 1;
}

init_mongo () {
	echo "Running MongDB start script!";

	# start without AUTH
	mongod -f $CONFIGFILE &
	LAST_PID=$!

	# wait for up
	echo "Waiting for MongoDB to start ($LAST_PID)"
	sleep 10 # todo: check if up instead
	echo "Done waiting..."

	# run init script (adding AUTH capabilities)
	# mongo /mapic/init_mongo.js
	echo "Running init_mongo.js script..."
	mongo --eval "var MAPIC_MONGO_AUTH = \"$MAPIC_MONGO_AUTH\"; var MAPIC_MONGO_DB = \"$MAPIC_MONGO_DB\"; var MAPIC_MONGO_USER = \"$MAPIC_MONGO_USER\"" /mapic/init_mongo.js
	echo "...done"


	# kill mongo
	echo "Stopping MongoDB ($LAST_PID)"
	kill $LAST_PID;

	# wait for down
	sleep 10 # todo: check if down instead
	echo "...done"

	# mark inited
	touch /data/db/mapic.inited
}

# ensure log dir
touch /etc/mongod.log

# if script has been updated, or never inited, run init_mongo
# if [[ /init_mongo.js -nt /data/db/mapic.inited ]]; then
	init_mongo || abort "Failed to initialize MongoDB. Quitting!"
# fi

echo "Starting MongoDB with AUTH";
mongod -f $CONFIGFILE --auth || abort "Failed to start MongodB. Quitting!"