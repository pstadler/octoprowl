#!/usr/bin/env ruby
require './octoprowl'

puts 'Running Octoprowl scheduler task...'
op = Octoprowl::Runner.new(ENV['prowl_api_key'])
num_matches = op.scan(ENV['gh_feed_url'], ENV['gh_username'])
puts "#{num_matches} notifications sent."