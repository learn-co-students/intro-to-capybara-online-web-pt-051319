# Intro To Capybara

## Overview

In this lesson, we'll discuss integration testing with Capybara.

## Objectives

1. Define an integration test and compare it to unit and controller tests.
2. Use Capybara for integration tests by including it in the testing environment
3. Use specific Capybara methods- `visit` and `page`- when writing tests
4. Read a Capybara test of response HTML.
5. Read a Capybara test that interacts with HTML.
6. Read a Capybara test that submits an HTML form.

## The MVC Framework

There are three basic levels of testing that correspond to the different levels of our application stack in a Model-View-Controller architecture.

![Web Application Stack and Tests](https://dl.dropboxusercontent.com/s/k2ypcn86btb6ajo/2015-09-29%20at%204.14%20PM.png)

**Database:** Databases persist or save data from our application. 

**Models:** Models provide an object-oriented abstraction or metaphor for the data in our application. Our models do the job of interacting with the database for us. Our model can talk to the database by asking for certain data and using that data to create a new instance of our class. We can then interact with that data by using the methods and properties of the instance of that class. 

**Controllers:** Controllers provide the main interface and application logic. They deal with things like: "What data should I show a user in response to certain input from that user" or "What HTML should be sent to the user when they visit the /about page?". In large scale MVC applications, controllers are represented by classes, but really, lots of `bin` files could be considered controllers.

**Views:** Views present information to the user. Any code that is responsible for presenting data or output to the user, from methods that use a bunch of `puts`, to HTML, to ERB templates, could be considered a View. In web applications, Views are generally represented by ERB templates that generate HTML.

**User/Browser:** The top of our application pyramid is finally the user. Whether describing the people using our application, the interface they use such as a Command Line, Voice, or HTML, or the program they use to even access our application, such as a Browser like Chrome or Safari, or a Native app, our application is responsible for delivering the user an experience on some sort of pre-existing platform.

#### Basic MVC Flow

Let's take a look at how it all fits together. We'll use an example of a social networking application.

1. The user interacts with our application's view(s), via the command line or a web browser, for example. The user enters some input that asks our application to show him or her a list of all of their friends who are using the application. 
2. The controller receives this request and looks at it. The controller says "okay, this user wants to see a list of their friends."
3. The controller asks the `Friends` model––"can you go into the database and bring back all of this user's friends?".
4. The model goes to the database, retrieves all of the requested data, and gives it to the controller. 
5. The controller passes that data to a view, and the view displays it to the user. 

## The Three Levels of Testing

### Unit Tests

Unit tests test the models in our application and how they interact with our database. 

### Controller Tests

Controller tests test that the code responsible for delivering the appropriate data to a user is working properly. In a web app, a controller test is responsible for making sure that an HTTP request returns the expected HTTP response. Controller tests should not test HTML or forms, but rather, that the controller behaved as expected.

### Integration Tests

Integration tests are the highest-level of test, and they are closest to describing how a user will actually interact with our application. Commonly referred to as End-To-End Tests, Integration tests should flex your entire application stack (i.e. all of the MVC components) and rarely isolate components or behaviors. They are perfect for spec'ing high level user interactions with HTML and forms. We're going to be learning how to write and read an integration test using a library called Capybara within an RSpec test suite.

*Note: While you will generally not be required to write tests in Learn, you will be required to read a test and understand what functionality the test suite is anticipating and testing. If you can write a test, we believe you can read a test.*

## Integration Testing with Capybara

### What is Capybara?

Capybara is a library of code that we can include in our application via the capybara gem. The Capybara library allows us to write code that simulates how a user interacts with our app. We can write such code in our integration tests and thus test the functionality of our application. 

### Capybara Setup

To use Capybara for integration tests in Rails or Sinatra, we need to include it in our testing environment. In our `spec/spec_helper.rb` file, we add the following code:

```ruby
# Load RSpec and Capybara
require 'rspec'
require 'capybara/rspec'
require 'capybara/dsl'

# Configure RSpec
RSpec.configure do |config|
  # Mixin the Capybara functionality into Rspec
  config.include Capybara::DSL
  config.order = 'default'
end

# Define the application we're testing
def app
  # Load the application defined in config.ru
  Rack::Builder.parse_file('config.ru').first
end

# Configure Capybara to test against the application above.
Capybara.app = app
```

The above code might look long and confusing. All you need to know is that it is configuring `RSpec` and our tests to be able to use all the wonderful methods and interactions Capybara provides.

The most important part of the configuration is the last line where we explicitly tell `Capybara` that the `app` we're testing against is defined in `config.ru`.

## Our Application

Consider a simple Web Application that shows the user a form asking for their name and then when they submit the form, the application will greet the user based on the name they inputted.

Our homepage, at "/", will display the form:

![Form](https://dl.dropboxusercontent.com/s/1zocl86jv9qguth/2015-09-29%20at%206.00%20PM%20%281%29.png)

Upon submitting the form, the application sends a `POST` request to the `POST '/greet'` route. Then, the user should see the following page:

![Response](https://dl.dropboxusercontent.com/s/83o4onopkwquuve/2015-09-29%20at%206.01%20PM.png)

Colloquially we could express the tests for this application as follows:

```
When a user visits '/'
  they should see a greeting
  they should see a form with a name field

When a user submits the greeting form
  they should fill in the name with "Avi"
  they should click submit
  they should see "Hi Avi, it's nice to meet you!"
```

It is exactly these sort of behaviors, conditions, and expectations that Capybara make very easy to read and test.

## Testing our Application

Now that our test suite is setup to use Capybara, let's start writing some tests for our application. **All of the code we will review below is already present in this repo. You can fork and clone this repo to take a closer look, or you can rebuild this simple app on your own as we review it together, below.**

### `GET '/'` 

We want our root path to show our greeting form:

![Form](https://dl.dropboxusercontent.com/s/1zocl86jv9qguth/2015-09-29%20at%206.00%20PM%20%281%29.png)

So, we want to write a test that checks that the `Get '/'` route brings the user to that page. 

Let's write this test in `spec/application_integration_spec.rb`.

File: `spec/application_integration_spec.rb`

```ruby
require 'spec_helper'

describe "GET '/' - Greeting Form" do
  it 'welcomes the user' do
    visit '/'
    expect(page.body).to include("Welcome!")
  end
end
```

Most of that code is actually vanilla RSpec. Capybara provides two new methods, `visit` and `page`.

#### Capybara `visit`

The `visit` method navigates the browser used during the test to a specific URL. It is equivalent to a user typing a URL into their browser's location bar.  The argument it accepts is a string for the URL you want to test. Since we want to test our `'/'` root URL, we say `visit '/'` and Capybara will load that page within our test.

#### Capybara `page`

The `page` method in capybara exposes the "session" or "browser" that is conceptually (and literally) being used during the test. The `page` method gives you a `Capybara::Session` object that represents the browser page the user would actually be looking at if they typed in `'/'` (or whatever argument you last passed to `visit`).

As such, `page` responds to a lot of methods that represent actions a user would do on a page, such as `click_link`, `fill_in`, and `body`.

The `page.body` will basically dump out all the HTML in the current page as a string.

Our test is telling Capybara to visit the `/` URL. It then sets the expectation that the body of the page returned should include at least the text `Welcome!` somewhere.

#### Passing the First Test

File: `./app.rb`

```ruby
class Application < Sinatra::Base
  get '/' do
    erb :index
  end
end
```

`./app.rb` is our main application file, defining the controller that will power this web application. We create a class `Application` and inherit from `Sinatra::Base` to give this class all the web super-powers needed to transform the ruby class into a Sinatra controller.

Within our `Application` controller, we use the Sinatra DSL to create a `GET` route at the `/` URL. We tell our application that in response to HTTP GET requests to `/`, render the ERB template or HTML as the response. 

The line `erb :index` tells the application to render, or deliver to the user's browser, the file in `views/index.erb`. This is a Sinatra provided functionality to render ERB templates located in the `views` directory. Let's look at that view file.

File: `views/index.erb`

```
<h1>Welcome!</h1>
```

Our ERB view `views/index.erb` (Sinatra will automatically look for the `.erb` extension when you call `erb` in the controller), contains the necessary HTML to make our test pass.

The final piece of the puzzle is a `config.ru` file to put everything together and start our Sinatra application. This is the file `shotgun` or `rackup` will read to start your local application server and it's also the file our test suite is using to define our application, remember `Rack::Builder.parse_file('config.ru').first`?

File: `./config.ru`

```ruby
require 'sinatra'

require_relative './app'

run Application
```

In a basic application like this example, our `config.ru` `require`s the `sinatra` gem. It then `require_relative`s the required file `app.rb` that defines our main `Application` controller. Finally, we `run` our `Application` controller to start our web application.

If we now start our application with `shotgun` and open `http://localhost:9393` in our browser we'll see our welcome message.

![Welcome](https://dl.dropboxusercontent.com/s/bue5icj3yuz6iol/2015-09-29%20at%208.56%20PM.png)

And when we run our test suite, we'll see:

```
$ rspec

GET '/' - Greeting Form
  welcomes the user

Finished in 0.03438 seconds (files took 0.43261 seconds to load)
1 example, 0 failures
```

If you receive an error output, don't worry, read it and see if you can figure out what's going on and fix it. If not, just move on, **this lesson is about understanding how to read a Capybara test**, not write them or debug them.

#### Passing the Second Test: Adding the Greeting Form Requirement

Great, step 1, get a basic test and application working, is done! Let's now add tests for the HTML form that will allow users to provide their name for the greeting. When our tests pass, our form at `/` will look like:

![Form](https://dl.dropboxusercontent.com/s/1zocl86jv9qguth/2015-09-29%20at%206.00%20PM%20%281%29.png)

So let's describe an expectation for that HTML in our test.

Edit: `spec/application_integration_spec.rb`

```ruby
require 'spec_helper'

describe "GET '/' - Greeting Form" do
  # Code from previous example
  it 'welcomes the user' do
    visit '/'
    expect(page.body).to include("Welcome!")
  end

  # New test
  it 'has a greeting form with a user_name field' do
    visit '/'

    expect(page).to have_selector("form")
    expect(page).to have_field(:user_name)
  end
end
```

Our new test has a similar setup to the first test, we need to tell Capybara to visit the page at `'/'`. Once that is done, we can set some expectations against the `page` object that represents the user looking at the homepage in their browser. We can simply assert that the `page` has an HTML selector for `form`, meaning that the page contains an HTML element that matches the `form` tag.

Where does this magic `have_selector` matcher come from? That's right, Capybara has added that to RSpec. Capybara `page` objects respond to methods that relate intimately to HTML and the DOM (Document Object Model) that defines web applications. You can literally ask the `page` object: "hey, do you have HTML that matches the following selector?" Pretty amazing, right?

The second expectation is similar, `expect(page).to have_field(:user_name)`
. We're saying that we expect the `page` to have a form field called `user_name`. We get to be even more semantic with the `have_field` matcher that will make sure the HTML in `page` contains a form input with either an `ID` or `name` attribute that matches the argument, in this case `:user_name`.

After editing the integration test and saving it, if we run our tests according to the current code, we'll see:

```
rspec

GET '/' - Greeting Form
  welcomes the user
  has a greeting form with a user_name field (FAILED - 1)

Failures:

  1) GET '/' - Greeting Form has a greeting form with a name field
     Failure/Error: expect(page).to have_selector("form")
       expected #has_selector?("form") to return true, got false
     # ./spec/application_integration_spec.rb:12:in `block (2 levels) in <top (required)>'

Finished in 0.03963 seconds (files took 0.42466 seconds to load)
2 examples, 1 failure

Failed examples:

rspec ./spec/application_integration_spec.rb:9 # GET '/' - Greeting Form has a greeting form with a name field
```

Our first test for welcoming the user still passes, but our new test fails. Let's zoom in on the meaningful part of the failure message.

```
Failure/Error: expect(page).to have_selector("form")
  expected #has_selector?("form") to return true, got false
```

The failure message is telling us that we expected the page to have an HTML form and it doesn't, so it's failing. Let's add our HTML form to our view and make this test pass.

Edit: `views/index.erb`

```html
<h1>Welcome!</h1>

<form action="/greet" method="POST">
  <label for="user_name">Name:</label>

  <p><input type="text" name="user_name" id="user_name" /></p>

  <input type="submit" value="Submit"/>
</form>
```

Don't worry about the specifics of the HTML form, but know that it is building an HTML form that when submitted by the user clicking on the Submit button, will create an HTTP POST request to `/greet`, submitting whatever the user typed into the form text `<input>` field nested in the form that happens to be `name` and `user_name` (I know confusing, but it's `name` attribute is equal to `user_name`).

Run your tests now or reload your browser and you should see the form and your tests passing.

### `POST '/greet'`

#### Passing Our Third Test: Processing the Form and Greeting the User

The final step of our greeting application is to teach our application how to accept the form that a user submits. We know that we want the outcome to be a custom greeting message based on what they type into the `user_name` field in the form. If you typed in `Avi` and clicked submit, we'd expect the page in our browser to look like:

![Response](https://dl.dropboxusercontent.com/s/83o4onopkwquuve/2015-09-29%20at%206.01%20PM.png)

Let's write those tests.

Add the following to the end of: `spec/application_integration_spec.rb` (under the closing `end` of the first `describe` block).

```ruby
describe "POST '/greet' - User Greeting" do
  it 'greets the user personally based on their user_name in the form' do
    visit '/'

    fill_in(:user_name, :with => "Avi")
    click_button "Submit"

    expect(page).to have_text("Hi Avi, nice to meet you!")
  end
end
```

This new test is trying to mimic a user visiting our greeting form, filling in their name, clicking the submit button, and what they should see in response. Because of the amazing `RSpec` DSL mixed in with `Capybara`, our test quite literally describe that behavior.

We `visit '/'` to load the form into the `page` object.

Then we use the Capybara method `fill_in` to fill in the input field `user_name` with `Avi`.

Finally, we `click_button "Submit"` to submit the form. That HTML interaction, submitting a form, will trigger a new HTTP request in the Capybara session and `page` object. 

Just like when you submit a form, the browser loads a new page and you see new content. When Capybara submits a form, just like when we call `visit`, the `page` object is appropriately updated. `page` no longer contains the original greeting form, but rather, after `click_button`, `page` now has the response to the greeting form.

For the response to submitting the greeting form, we can `expect` the `page` to `have_text` `"Hi Avi, nice to meet you!"`. The user filled in their user_name as "Avi", the resulting greeting should mention that. `have_text` is another really friendly and semantic Capybara matcher for testing HTML text value explicitly.

After adding this test, if we run our test suite, we'll see:

```ruby
GET '/' - Greeting Form
  welcomes the user
  has a greeting form with a user_name field

POST '/greet' - User Greeting
  greets the user personally based on their user_name in the form (FAILED - 1)

Failures:

  1) POST '/greet' - User Greeting greets the user personally based on their user_name in the form
     Failure/Error: expect(page).to have_text("Hi Avi, nice to meet you!")
       expected #has_text?("Hi Avi, nice to meet you!") to return true, got false
     # ./spec/application_integration_spec.rb:24:in `block (2 levels) in <top (required)>'

Finished in 0.05962 seconds (files took 0.42668 seconds to load)
3 examples, 1 failure

Failed examples:

rspec ./spec/application_integration_spec.rb:18 # POST '/greet' - User Greeting greets the user personally based on their user_name in the form
```

Our first two tests relating to `GET '/'` pass, but our new test is failing. Zooming in on the failure:

```
1) POST '/greet' - User Greeting greets the user personally based on their user_name in the form
   Failure/Error: expect(page).to have_text("Hi Avi, nice to meet you!")
     expected #has_text?("Hi Avi, nice to meet you!") to return true, got false
```

When submitting a POST request to `/greet`, if the `user_name` was filled in with `Avi`, we expected the resulting page to contain the text `"Hi Avi, nice to meet you!"`. Unfortunately, at this point, it does not.

To make this pass we need to add two things. Currently, our Sinatra application only responds to a single HTTP request, `GET` requests to `/`. We need to teach it to respond to `POST` requests to `/greet`. Let's do that.

Edit: `./app.rb`

```ruby
class Application < Sinatra::Base
  # Old route from previous tests
  get '/' do
    erb :index
  end

  # New route to respond to the form submission
  post '/greet' do
    erb :greet
  end
end
```

Using the Sinatra `post` method, we create a response for requests to `POST '/greet'`. That response should be the HTML contained in the `views/greet.erb` template, just like the HTML response of our first route was contained in `views/index.erb`.

The next step is to build our view in `views/greet.erb`. The point of this view is to use the data the user submitted in the previous form within our HTML to produce a personalized greeting for the user.

File: `views/greet.erb`

```html
<h1>Hi <%= params[:user_name] %>, nice to meet you!</h1>
```

That HTML and ERB will satisfy our test.

If you are unfamiliar with the `params` object and how it relates to form and inputs, that's totally fine. The tl;dr is that all the information the user submitted in the form is available to your code within a hash `params`. `params[:user_name]` returns the text the user put into the form input field `user_name`. `<%= params[:user_name] %>` uses ERB's embedded ruby to dynamically insert the value of `params[:user_name]` into the HTML of the response.

With this code in place, our tests should pass and if we refresh our browser and submit the form it should behave as expected.

That's it, you totally crushed Capybara and Integration testing.

## Summary

We learned about:

1. Integration Tests - Tests that exercise the outermost part of our application code from the perspective of our user, actually interacting with the application via it's interface  like a web browser and HTML.
2. Capybara - A Ruby library that works with RSpec to allow you to write extremely powerful, simple, and semantic Integration Tests for Web Applications.
3. `visit`, `page` - Capybara methods for controlling the test user's browser and introspecting on the current state of the page they are looking at.
4. `have_selector`, `have_field`, `have_text` - Capybara matchers for ensuring that the page contains certain matching HTML or text.
5. `fill_in`, `click_button` - Capybara methods for mimicking user activity like filling in form fields or clicking buttons.
6. A simple Sinatra Form Application - We also built a simple Sinatra application that has two routes, a GET and a POST, displaying a form, accepting the form input, and sending a dynamic response.

Great job!

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/intro-to-capybara' title='Intro To Capybara'>Intro To Capybara</a> on Learn.co and start learning to code for free.</p>

<p class='util--hide'>View <a href='https://learn.co/lessons/intro-to-capybara'>Intro to Capybara Tests</a> on Learn.co and start learning to code for free.</p>
