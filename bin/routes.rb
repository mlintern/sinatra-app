get "/" do
  erb :index, :layout => :bs_skin, :locals => { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/index.css">' }
end

get "/signup" do
  erb :signup, :layout => :bs_skin, :locals => { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/signup.css">' }
end

post "/users" do
  user = User.create(params[:user])
  user.username.downcase!
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
  if user.save
    flash[:info] = "Thank you for registering #{user.username}" 
    session[:user] = user.token
    redirect "/login" 
  else
    session[:errors] = user.errors.full_messages
    redirect "/signup?" + hash_to_query_string(params[:user])
  end
end

post "/users/:id" do
  @user2 = params[:user]
  if @user = User.first(:id => params[:id])
    @user2.each do |key,val|
      unless @user[key] == @user2[key]
        @user.update({key => val, :password => "123456", :password_confirmation => "123456"})
      end
    end
  else
    flash[:error] = "Could not find user with id:  #{user.id}!"
  end
  redirect "/app/profile"
end

post "/users/:id/password" do
  if ( ( @user = User.first(:id => params[:id]) ) && ( params[:user][:password] == params[:user][:password_confirmation] ) )
    password_hash = BCrypt::Engine.hash_secret(params[:user][:password], @user.password_salt)
    puts @user.update({:password_hash => password_hash, :password => "123456", :password_confirmation => "123456"})
  else
    flash[:error] = "Could not find user with id:  #{user.id}!"
  end
  redirect "/app/profile"
end

get "/login" do
  if current_user
    redirect_last
  else
    erb :login, :layout => :bs_skin, :locals => { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/login.css">' }
  end
end

post "/login" do
  if user = User.first(:username => params[:username].downcase)
    if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
    session[:user] = user.token 
    response.set_cookie "user", {:value => user.token, :expires => (Time.now + 52*7*24*60*60)} if params[:remember_me]
    redirect "/app"
    else
      flash[:error] = "Username/Password combination does not match"
      redirect "/login?username=#{params[:username]}"
    end
  else
    flash[:error] = "That email address is not recognised"
    redirect "/login?username=#{params[:username]}"
  end
end

get "/logout" do
  current_user.generate_token
  response.delete_cookie "user"
  session[:user] = nil
  flash[:info] = "Successfully logged out"
  redirect "/"
end

get "/app" do
  login_required

  erb :app, :layout => :bs_skin, :locals => { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/app.css">' }
end

get "/app/settings" do
  admin_required

  all_users = User.all

  erb :settings, :layout => :bs_skin, :locals => { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/settings.css">', 'all_users' => all_users }
end

get "/app/profile" do
  erb :profile, :layout => :bs_skin, :locals => { 'extra_style_sheet' => '<link rel="stylesheet" href="/css/profile.css">', 'user' => current_user }
  # "<pre>id: #{current_user.id}\nemail: #{current_user.email}\nadmin? #{current_user.admin}</pre>"
end
