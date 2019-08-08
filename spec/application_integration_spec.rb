require 'spec_helper'

describe "GET '/' - Greeting Form" do
	# Code from previous example
	it 'welcomes the user' do
		visit '/'
		expect(page.body).to include('Welcome!')
	end

	# New test
	it 'has a greeting form with a user_name field' do
		visit '/'

		expect(page).to have_selector('form') # Set expectgations against the page object, assert that the page has an HTML selector for form tag
		expect(page).to have_field(:user_name) # Expect the page to have form field called user_name
	end
end

describe "POST '/greet' - User Greeting" do
	it 'greets the user personally based on their user_name in the form' do
		visit '/'

		fill_in(:user_name, with: 'Avi') # takes the argument from line 15 and fill it with:
		click_button 'Submit'

		expect(page).to have_text('Hi Avi, nice to meet you!')
	end
end
