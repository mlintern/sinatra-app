# encoding: utf-8
# frozen_string_literal: true
helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  # Convert a hash to a querystring forform population
  def hash_to_query_string(hash)
    hash.delete 'password'
    hash.delete 'password_confirmation'
    hash.collect { |k, v| "#{k}=#{v}" }.join('&')
  end

  # Redirect to last page or root
  def redirect_last
    if session[:redirect_to]
      redirect_url = session[:redirect_to]
      session[:redirect_to] = nil
      redirect redirect_url
    else
      redirect '/'
    end
  end

  # Require login to view page
  def login_required
    if session[:user]
      session[:redirect_to] = request.fullpath
      return true
    end
    flash[:info] = 'Login is required.'
    redirect '/login'
    false
  end

  # Require admin flag to view page
  def admin_required
    if current_user && admin?
      session[:redirect_to] = request.fullpath
      return true
    end

    flash[:info] = 'Admin rights required to view the settings page.'
    redirect_last
  end

  # Check user has admin flag
  def admin?
    current_user.admin?
  end

  # Check logged in user is the owner
  def owner?(owner_id)
    return true if current_user && current_user.id.to_i == owner_id.to_i
    flash[:info] = 'You are not authorised to view that page.'
    redirect '/app'
    false
  end

  # Return current_user record if logged in
  def current_user
    return @current_user ||= User.first(token: request.cookies['user']) if request.cookies['user']
    @current_user ||= User.first(token: session[:user]) if session[:user]
  end

  # check if user is logged in?
  def logged_in?
    session[:user]
  end

  # Loads partial view into template. Required vriables into locals
  def partial(template, locals = {})
    erb(template, layout: false, locals: locals)
  end
end

# Clear out sessions
at_exit do
  session[:errors] = nil
end
