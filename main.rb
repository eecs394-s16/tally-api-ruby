require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'sequel'
require 'bcrypt'
require 'rest-client'

environment = ENV["RAILS_ENV"] || 'DEV'

# Setup DB
DB = nil
if environment == 'DEV'
  DB = Sequel.connect("postgres://postgres:bugzzues@localhost:5432/tally_api_ruby")
elsif environment == 'PROD'
  DB = Sequel.connect("postgres://#{ENV["DB_USER"]}:#{ENV["DB_PASS"]}@localhost:5432/tally_api_ruby")
end

# Reset DB if env is set
if ENV['RESET_DB'] == '1'
  require_relative 'scripts/create_tables.rb'
end


# Include models and routes
require_relative 'models/init.rb'
require_relative 'routes/init.rb'

## Sinatra Settings
set :port   => 3002
set :server => 'thin'
set :bind   => '0.0.0.0'
set :show_exceptions, false

configure do
  enable :cross_origin
end

options '*' do
  # Needed for AngularJS
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
end
