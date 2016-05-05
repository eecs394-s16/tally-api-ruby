require 'json'
require 'sequel'
require 'bcrypt'

environment = ENV["RAILS_ENV"] || 'DEV'

# Setup DB
DB = nil
if environment == 'DEV'
  DB = Sequel.connect("postgres://postgres:bugzzues@localhost:5432/glass")
elsif environment == 'PROD'
  DB = Sequel.connect("postgres://lucidgoose:#{ENV["DB_PASS"]}@#{ENV['DB_PORT_5432_TCP_ADDR']}:#{ENV['DB_PORT_5432_TCP_PORT']}/glass")
end

# Include models, routes, and services
require_relative '../models/init.rb'
require_relative '../services/init.rb'
