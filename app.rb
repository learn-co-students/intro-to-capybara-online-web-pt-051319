class Application < Sinatra::Base

	attr_accessor = :name

	get('/'){ erb :index }
	post('/greet'){ erb :greet }
end