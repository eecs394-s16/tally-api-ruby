require 'sequel'

DB = Sequel.connect('postgres://postgres:bugzzues@localhost:5432/tally_api_ruby') if ENV['RAILS_ENV'].nil?

require_relative '../schemas/init.rb'
