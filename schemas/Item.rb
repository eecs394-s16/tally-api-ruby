DB.create_table! :Item do
  primary_key :id
  foreign_key :collection_fk, :Collection

  String :name
  Fixnum :price # Price in cents
end
