# Create new user
post '/users' do
  payload = JSON.parse(request.body.read)

  # Create user
  user = User.new
  user.username  = payload["username"]
  user.pinterest = payload["pinterest"]
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
