require "sinatra"
require "sinatra/flash"

set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions

require "./bin/helpers"
require "./bin/models"
require "./bin/routes"

# This is to create initial users for application
require "./bin/user_create"

run Sinatra::Application