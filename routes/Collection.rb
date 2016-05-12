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
  id = params['id']
  session = Session.fromKey(request.env['HTTP_AUTHORIZATION'])
  user = session.getField('user')


  collection = user.getCollection(id)

  items = collection.getItems().map { |e| e.values }

  # Response
  content_type :json
  status(200)
  return {
    collection: collection.values,
    items: items}.to_json
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
  puts 1
  url = "https://api.pinterest.com/v1/boards/" + params[:id] + "/pins/?access_token=#{user.pinterest}"
  res = RestClient.get url
  puts 2
  puts res
  res = JSON.parse(res)
  puts res

  # Create new collection
  collection = Collection.new
  collection.user_fk = user.id
  collection.name = payload["name"]
  collection.save

  # Create items from pinterest board and add to collection
  items = []
  res["data"].each do |item|
    new_item = Item.new
    new_item.collection_fk = collection.id
    new_item.name  = item["note"]
    new_item.price = 0
    new_item.save
    items.push(new_item.values)
  end
  puts 3
  # Response
  content_type :json
  status(200)
  return {
    collection: collection.values,
    items: items
  }.to_json
end
