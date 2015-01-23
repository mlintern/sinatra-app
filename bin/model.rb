require 'bcrypt'
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db.sqlite")

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, key: true
  property :username, String, length: 128
  property :password, BCryptHash

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
end

# Tell DataMapper the models are done being defined
DataMapper.finalize

# Update the database to match the properties of User.
DataMapper.auto_upgrade!

# Create a test User
if User.count == 0
  @Admin = User.create(username: "admin")
  @Admin.password = "password"
  @Admin.save
end

# Create a test User
if User.count == 1
  @user = User.create(username: "user")
  @user.password = "password"
  @user.save
end