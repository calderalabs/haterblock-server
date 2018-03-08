#!/bin/bash
docker-compose up -d

mix local.hex --force
mix local.rebar --force
mix do deps.get, deps.compile
