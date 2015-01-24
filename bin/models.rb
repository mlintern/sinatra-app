require "data_mapper"
require "bcrypt"
require "securerandom"

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db.sqlite")

class User 
  include DataMapper::Resource
  
  attr_accessor :password, :password_confirmation

  property :id,             Serial
  property :username,       String,     :required => true, :unique => true
  property :first_name,     String
  property :last_name,      String
  property :email,          String,     :format => :email_address
  property :password_hash,  Text  
  property :password_salt,  Text
  property :token,          String
  property :created_at,     DateTime
  property :admin,          Boolean,    :default => false
  
  validates_presence_of         :password
  validates_confirmation_of     :password
  validates_length_of           :password, :min => 6

  after :create do
    self.token = SecureRandom.hex
  end

  def generate_token
    self.update!(:token => SecureRandom.hex)
  end

  def admin?
    self.admin
  end

end

DataMapper.finalize
DataMapper.auto_upgrade!
