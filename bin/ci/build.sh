#!/bin/bash
mix local.hex --force
mix local.rebar --force
mix do deps.get, deps.compile
