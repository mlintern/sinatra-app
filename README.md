This is a Shell for a Sinatra Application build on a Bootstrap template.

###To Start:

1. Download the Repo
2. bundle install
3. bundle exec rackup config.ru 
4. Navigate to localhost:9292
5. Login with <em>administrator</em> and <em>password</em>

###Endpoints:

get "/"
get "/signup"
post "/api/users"
post "/api/users/:id"
post "/api/users/:id/password"
get "/login"
post "/login"
get "/logout"
get "/app"
get "/app/settings" 
get "/app/profile"



## Deployment

bundle install --deployment
