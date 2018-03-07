#!/bin/bash
mix local.hex --force
mix local.rebar --force
mix do deps.get, deps.compile

apt-get update
apt-get install postgresql-10.3
createuser postgres
psql -c "ALTER USER postgres PASSWORD '';"
service postgresql restart
