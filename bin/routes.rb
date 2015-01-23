get "/" do
  erb :index, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/index.css">' }
end

get "/signup" do
  erb :signup
end

post "/signup" do
  puts params.inspect
  user = User.create(params[:user])
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
  if user.save
    flash[:info] = "Thank you for registering #{user.username}" 
    session[:user] = user.token
    redirect "/" 
  else
    session[:errors] = user.errors.full_messages
    redirect "/signup?" + hash_to_query_string(params[:user])
  end
end

get "/login" do
  if current_user
    redirect_last
  else
    erb :login, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/login.css">' }
  end
end

post "/login" do
  if user = User.first(:username => params[:username])
    if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
    session[:user] = user.token 
    response.set_cookie "user", {:value => user.token, :expires => (Time.now + 52*7*24*60*60)} if params[:remember_me]
    redirect_last
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

  erb :app, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/app.css">' }
end

get "/app/settings" do
  admin_required

  erb :settings, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/settings.css">' }
end

get "/app/profile" do
  "<pre>id: #{current_user.id}\nemail: #{current_user.email}\nadmin? #{current_user.admin}</pre>"
end
