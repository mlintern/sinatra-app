# encoding: utf-8
# frozen_string_literal: true
unless User.first(username: 'administrator')
  puts '---- Creating Admin ----'
  user = User.create(username: 'administrator', password: '123456', password_confirmation: '123456')
  user.first_name = 'Sinatra'
  user.last_name = 'Admin'
  user.email = 'admin@sinatra-app.com'
  user.admin = true
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret('password', user.password_salt)
  if user.save
    puts '---- Created Admin ----'
  else
    puts '---- Failed Saving Admin ----'
  end
end

unless User.first(username: 'mweston')
  user = User.create(username: 'mweston', password: '123456', password_confirmation: '123456')
  user.first_name = 'Michael'
  user.last_name = 'Weston'
  user.email = 'michael.weston@sinatra-app.com'
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret('password', user.password_salt)
  user.save
end

unless User.first(username: 'fglenanne')
  user = User.create(username: 'fglenanne', password: '123456', password_confirmation: '123456')
  user.first_name = 'Fiona'
  user.last_name = 'Glenanne'
  user.email = 'fiona.glenanne@sinatra-app.com'
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret('password', user.password_salt)
  user.save
end

unless User.first(username: 'saxe')
  user = User.create(username: 'saxe', password: '123456', password_confirmation: '123456')
  user.first_name = 'Sam'
  user.last_name = 'Axe'
  user.email = 'sam.axe@sinatra-app.com'
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret('password', user.password_salt)
  user.save
end

unless User.first(username: 'jporter')
  user = User.create(username: 'jporter', password: '123456', password_confirmation: '123456')
  user.first_name = 'Jesse'
  user.last_name = 'Porter'
  user.email = 'jesse.porter@sinatra-app.com'
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret('password', user.password_salt)
  user.save
end
