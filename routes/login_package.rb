# Create new user
post '/users' do
  payload = JSON.parse(request.body.read)

  # Get pinterest access token from oauth code
  # url =  "https://api.pinterest.com/v1/oauth/token?grant_type=authorization_code"
  # url += "&client_id=4832859821489269966"
  # url += "&client_secret=8155dc44611a08133cec68f4c36ba76d86548665c496c1d968cf59bf18d6b38b"
  # url += "&code=#{payload['pinterest']}"
  # res = JSON.parse(RestClient.post url, :accept => :json)

  # Check if access token is valid
  url = "https://api.pinterest.com/v1/me?access_token=#{payload['access_token']}"
  res = RestClient.get url
  if res.code != 200
    raise HttpError.new(401), "Access token not valid"
  end

  # Create user
  user = User.new
  user.username  = payload["username"]
  user.pinterest = payload["access_token"]
  user.setPassword(payload["password"])
  user.save

  # Create session
  session = Session.new
  session.setUser(user.id)
  session.save

  # Response
  content_type :json
  status(200)
  return {
      user: user.values,
      session: session.values
  }.to_json
end

# Update user
put '/users' do
  payload = JSON.parse(request.body.read)

  # Get session
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])

  # Update user
  user = session.getField('user')
  user.setPassword(payload["password"]) if payload["password"]
  user.save

  # Response
  content_type :json
  status(200)
  return user.values.to_json
end

# Delete user
delete '/users' do
  # Get session
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])

  # Update user
  user = session.getUser()
  user.destroy

  # Response
  content_type :json
  status(200)
  return {:deleted => user.values}.to_json
end

# Login user
post '/login' do
  payload = JSON.parse(request.body.read)

  # Get user from username
  user = User[:username => payload["username"]]
  if user == nil
    raise "No user found with username"
  end
  user.checkPassword(payload["password"])

  # Create new session
  session = Session.new
  session.setUser(user.id)
  session.save

  # Response
  content_type :json
  status(200)
  return {user: user.values, session: session.values}.to_json
end

# Logout user
post '/logout' do
  # Get session
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  session.destroy

  # Response
  content_type :json
  status(200)
  return {deleted: session.values}.to_json
end

# Get session data
get '/session' do

  # Get session
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])

  # Get user
  user = session.getField('user')

  # Response
  content_type :json
  status(500)
  return {:session => session.values, :user => user.values}.to_json
end
