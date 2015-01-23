require "sinatra"
require "sinatra/flash"

set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions

require "./bin/helpers"
require "./bin/models"
require "./bin/routes"

run Sinatra::Application