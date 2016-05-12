DB.create_table! :Item do
  primary_key :id
  Fixnum :collection_fk#, :Collection, :on_delete => :cascade

  String :name
  Fixnum :price # Price in cents
end
