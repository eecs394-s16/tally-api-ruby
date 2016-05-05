DB.create_table! :User do
  primary_key :id
  String      :username, :null => false, :unique => true
  String      :password, :null => false

  String      :pinterest, :null => false, :unique => true
end

DB.create_table! :Session do
  primary_key :id
  Fixnum      :user_fk, :null => false
  String      :session_key, :null => false, :unique => true
end
