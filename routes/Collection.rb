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

get '/pinterest/collections' do
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')
  url = "https://api.pinterest.com/v1/me/boards/?access_token=#{user.pinterest}&fields=id%2Cname%2Curl"
  res = RestClient.get url

  status(200)
  content_type :json
  return res
end

post '/pinterest/collections/:id/import' do
  payload = JSON.parse(request.body.read)
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')

  # Find pinterest board
  url = "https://api.pinterest.com/v1/boards/" + params[:id] + "/pins/?access_token=#{user.pinterest}"
  res = RestClient.get url

  # Create new collection
  # collection = Collection.new
  # collection.user_fk = user.id
  # collection.save

  # Create items from pinterest board and add to collection
  # TODO

  # Response
  content_type :json
  status(200)
  return res
end
