DB.create_table! :Collection do
  primary_key :id
  Fixnum :user_fk#, :User, :on_delete => :cascade

  String :name
end
