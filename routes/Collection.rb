get '/collections' do
  payload = JSON.parse(request.body.read)
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')

  # Create new collection
  collections = Collection.where(:user_fk => user.id)

  # Response
  content_type :json
  status(200)
  return {collections: collections}.to_json
end

get '/collections/:id' do
  payload = JSON.parse(request.body.read)
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')

  collection = user.getCollection(params['id'])

  # Response
  content_type :json
  status(200)
  return {collection: collection}.to_json
end

post '/collections' do
  payload = JSON.parse(request.body.read)
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')

  # Create new collection
  collection = Collection.new
  collection.user_fk = user.id
  collection.save

  # Response
  content_type :json
  status(200)
  return {collection: collection}.to_json
end

post '/collections/:id/items' do
  payload = JSON.parse(request.body.read)
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')
  collection = Collection.fromID(params['id'])

  # Create new item
  item = Item.new
  item.collection_fk = collection.id
  item.name  = payload["name"]
  item.price = payload["price"]
  item.save

  # Response
  content_type :json
  status(200)
  return {collection: collection}.to_json
end

post '/import/collections/pinterest' do
  payload = JSON.parse(request.body.read)
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')

  # Find pinterest board
  # TODO

  # Create new collection
  collection = Collection.new
  collection.user_fk = user.id
  collection.save

  # Create items from pinterest board and add to collection
  # TODO

  # Response
  content_type :json
  status(200)
  return {collection: collection}.to_json
end
