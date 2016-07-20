# encoding: utf-8
# frozen_string_literal: true
get '/' do
  session[:redirect_to] = request.fullpath
  erb :index, layout: :'layouts/bs_skin', locals: { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/index.css">' }
end

get '/signup' do
  session[:redirect_to] = request.fullpath
  erb :signup, layout: :'layouts/bs_skin', locals: { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/signup.css">' }
end

post '/api/users' do
  user = User.create(params[:user])
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
  puts user.inspect
  if user.save
    flash[:info] = "Thank you for registering #{user.username}"
    session[:user] = user.token
    session[:errors] = nil
    redirect '/login'
  else
    session[:errors] = user.errors.full_messages
    redirect '/signup?' + hash_to_query_string(params[:user])
  end
end

get '/api/users/:id' do
  admin_required

  @user = User.first(id: params[:id])
  if @user
    erb :profile, layout: :'layouts/bs_skin', locals: { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/profile.css">', 'user' => @user }
  else
    flash[:info] = "Could not find user with id: #{user.id}!"
  end
end

post '/api/users/:id' do
  @user2 = params[:user]
  @user = User.first(id: params[:id])
  if @user
    @user2.each do |key, val|
      unless @user[key] == @user2[key]
        @user.update(key => val, :password => '123456', :password_confirmation => '123456')
      end
    end
  else
    flash[:info] = "Could not find user with id:  #{user.id}!"
  end
  redirect_last
end

post '/api/users/:id/password' do
  if (@user = User.first(id: params[:id])) && (params[:user][:password] == params[:user][:password_confirmation])
    password_hash = BCrypt::Engine.hash_secret(params[:user][:password], @user.password_salt)
    puts @user.update(password_hash: password_hash, password: '123456', password_confirmation: '123456')
  else
    flash[:error] = "Could not find user with id:  #{user.id}!"
  end
  redirect_last
end

get '/login' do
  if current_user
    redirect_last
  else
    erb :login, layout: :'layouts/bs_skin', locals: { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/login.css">' }
  end
end

post '/login' do
  user = User.first(username: params[:username])
  if user
    if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
      session[:user] = user.token
      response.set_cookie 'user', value: user.token, expires: (Time.now + 52 * 7 * 24 * 60 * 60) if params[:remember_me]
      redirect '/app'
      session[:errors] = nil
    else
      flash[:info] = 'Username/Password combination does not match'
      redirect "/login?username=#{params[:username]}"
    end
  else
    flash[:info] = 'That username is not recognised'
    redirect "/login?username=#{params[:username]}"
  end
end

get '/logout' do
  current_user.generate_token
  response.delete_cookie 'user'
  session[:user] = nil
  session[:errors] = nil
  flash[:info] = 'Successfully logged out'
  redirect '/'
end

get '/app' do
  login_required

  erb :app, layout: :'layouts/bs_skin', locals: { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/app.css">' }
end

get '/app/settings' do
  admin_required

  all_users = User.all

  erb :settings, layout: :'layouts/bs_skin', locals: { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/settings.css">', 'all_users' => all_users }
end

get '/app/profile' do
  session[:redirect_to] = request.fullpath
  erb :profile, layout: :'layouts/bs_skin', locals: { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/profile.css">', 'user' => current_user }
end
