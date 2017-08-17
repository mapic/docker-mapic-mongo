#!/bin/bash

# build
docker build -t mapic/mongo:latest .

docker push mapic/mongo:latest