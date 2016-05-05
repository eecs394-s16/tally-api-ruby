# Custom HttpError
class HttpError < StandardError
  attr_reader :status

  def initialize(status=400)
    @status = status
  end
end

# Handle errors
error Sequel::Error do
  e = env['sinatra.error']
  content_type :json
  status(400)
  return {
    message: e.message
  }.to_json
end

error HttpError do
  e = env['sinatra.error']
  content_type :json
  status(e.status)
  return { error: e.message }.to_json
end

error do
  e = env['sinatra.error']
  status(500)
  return e.message.to_json
end

# Ping route
get '/' do
  status(200)
  return "API Online!"
end

# Custom routes
require_relative 'Collection.rb'

# Packages
require_relative 'login_package.rb'
