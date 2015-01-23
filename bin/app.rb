require 'rubygems'
require 'sinatra'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
    erb :index, :layout => :skin
end

get %r{/hello(/)?} do
    greeting = params[:greeting] || "Hi There"
    erb :hello, :layout => :skin, :locals => {'greeting' => greeting}
end