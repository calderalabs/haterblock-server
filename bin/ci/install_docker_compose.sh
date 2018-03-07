#!/bin/bash

set -e

curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` > ./docker-compose
chmod +x ./docker-compose
./docker-compose up -d
