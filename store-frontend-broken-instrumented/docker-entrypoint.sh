#!/bin/bash
# This is entrypoint for docker image of spree sandbox on docker cloud

cd store-frontend && RAILS_ENV=development RUBYOPT='-W0' SEMANTIC_LOGGER_APP='store-frontend' puma --config config/puma.rb
