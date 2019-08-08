class Application < Sinatra::Base
	# Write your code here!
	get '/' do
		# create a GET route at the / URL
		erb :index # respond to HTTP GET requests to / by rendering the designated ERB template or HTML in views/index.erb
	end

	# New route ot respond to the form submission
	post '/greet' do
		erb :greet
	end
end # end of Class
