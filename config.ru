#!/usr/bin/env rackup
# encoding: utf-8

# This file can be used to start Padrino,
# just execute it from the command line.

require File.expand_path("../config/boot.rb", __FILE__)
require File.expand_path("../app/api/api.rb", __FILE__)

run Rack::Cascade.new [CkTieba::API, Padrino.application]
# run Padrino.application
