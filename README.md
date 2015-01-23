This is a Shell for a Sinatra Application build on a Bootstrap template.

###To Start:

1. Download the Repo
2. bundle install
3. rackup config.ru
4. Navigate to localhost:9292
5. Login with <em>administrator</em> and <em>password</em>

###Endpoints:

GET / - index view

GET /demo(/)? - Will resond with a default greeting of 
	- you can specifify a greeting by passing a greeting via a greeting var 

GET /login(/)?