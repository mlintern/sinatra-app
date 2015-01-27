require "sinatra"
require "sinatra/flash"
require 'bundler/setup'

set :public_folder, "public"
set :views, "views"
enable :sessions, :static

require "./bin/helpers"
require "./bin/models"
require "./bin/routes"

# This is to create initial users for application
require "./bin/user_create"

run Sinatra::Application