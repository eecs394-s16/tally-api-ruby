## User Model
class User < Sequel::Model(:User)
  include BCrypt

  def setPassword(new_password)
    if new_password.nil?
      fail HttpError.new(400), "password cannot be empty!"
    end

    if new_password.length < 8
      fail HttpError.new(400), "password must be greater than 8 characters!"
    end

    self.password = Password.create(new_password)
  end

  def checkPassword(password)
    if Password.new(self.password) != password
      fail HttpError.new(403), "Incorrect password"
    end
  end

  def getCollection(id)
    # Get collection from id
    collection = Collection.fromID(id)

    # Check that collection belongs to user
    raise HttpError.new(403), "This collection does not belong to you!" if collection.user_fk != self.id

    return collection
  end
end

## Session Model
class Session < Sequel::Model(:Session)
  include BCrypt

  def setUser(user_id)
    self.user_fk     = user_id
    self.session_key = Password.create(Time.now + user_id)
    self.session_key = self.session_key.gsub('/', '')
  end

  def self.fromKey(key)
    session = Session[:session_key => key]
    raise HttpError.new(404), "Could not find session with key #{key}" if session.nil?
    return session
  end
end
