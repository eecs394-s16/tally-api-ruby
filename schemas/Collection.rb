DB.create_table! :Collection do
  primary_key :id
  foreign_key :user_fk, :User
end
