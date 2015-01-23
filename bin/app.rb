require 'bundler'
Bundler.require

# load the Database and User model
require './bin/model'

set :port, 8080

class App < Sinatra::Base
  set :static, true
  set :public_folder, "static"
  set :views, "views"
  enable :sessions
  register Sinatra::Flash

  use Warden::Manager do |config|
    # Tell Warden how to save our User info into a session.
    # Sessions can only take strings, not Ruby code, we'll store
    # the User's `id`
    config.serialize_into_session{|user| user.id }
    # Now tell Warden how to take what we've stored in the session
    # and get a User from that information.
    config.serialize_from_session{|id| User.get(id) }

    config.scope_defaults :default,
      # "strategies" is an array of named methods with which to
      # attempt authentication. We have to define this later.
      strategies: [:password],
      # The action is a route to send the user to when
      # warden.authenticate! returns a false answer. We'll show
      # this route below.
      action: 'unauthenticated'
    # When a user tries to log in and cannot, this specifies the
    # app to send the user to.
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.first(username: params['user']['username'])

      if user.nil?
        fail!("The username you entered does not exist.")
      elsif user.authenticate(params['user']['password'])
        success!(user)
      else
        fail!("Could not log in")
      end
    end

  end

  get '/' do
    erb :index, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/index.css">' }
  end

  get '/login' do
    erb :login, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/login.css">' }
  end

  post '/login' do
    env['warden'].authenticate!

    flash[:success] = env['warden'].message

    if session[:return_to].nil?
      redirect '/app'
    else
      redirect session[:return_to]
    end
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    flash[:success] = 'Successfully logged out'
    redirect '/'
  end

  post '/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
    puts env['warden.options'][:attempted_path]
    puts env['warden']
    flash[:error] = env['warden'].message || "You must log in"
    redirect '/login'
  end

  get '/app' do
    env['warden'].authenticate!

    erb :app, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/app.css">' }
  end

  get '/app/settings' do
    env['warden'].authenticate!

    erb :settings, :layout => :bs_skin, :locals => {'extra_style_sheet' => '<link rel="stylesheet" href="/css/settings.css">' }
  end
end