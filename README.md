# Intro To Capybara

## Objectives

1. Understand what an integration test is compared to unit and controller tests.
2. Understand how to read a Capybara test of response HTML.
3. Understand how to read a Capybara test that interacts with HTML.
4. Understand how to read a Capybara test that submits an HTML form.

## What is an Integration Test

There are three basic levels of testing that correspond to the different levels of our application stack.

![Web Application Stack and Tests](https://dl.dropboxusercontent.com/s/k2ypcn86btb6ajo/2015-09-29%20at%204.14%20PM.png)

### Unit Tests

All the way at the bottom of our application is our database. We rarely interact with the database directly and generally build objects, called models, that encapsulate database interactions. These units of work that are model oriented and provide interfaces for reading and writing data to the database get tested via Unit tests. Unit tests should isolate the expected data behavior regardless of interface.

### Controller Tests

A level up from our database and models are our controllers. In a web application controllers are responsible for responding to the request by assembling all the data and HTML that will compose our response. We test controllers with controller tests. A controller test should be soley responsible for making sure that an HTTP request returns the expected HTTP response. Controller tests should not test HTML or forms, but rather, that the controller behaved as expected.

### Integration Tests

Integration tests are the highest-level of test, they are closest to describing how a user will actually interact with our application. Commonly referred to as End-To-End Tests, Integration tests should flex your entire application stack and rarely isolte components or behaviors. They are perfect for spec'ing high level user interactions with HTML and forms.

## Outline

1. What is an Integration Test?
  - Unit Tests
  - Controller Tests
  - Integration Tests

2. Testing a Web Application
  - Testing Units
  - Testing Controllers
  - Testing the Application (End to End / Integration)

3. Integration Tests with Capybara
  - visit
  - page
  - expectations
  - mimicking user behavior
    - click
    - fill_in
  - using behavior and expectations

This lab should use a simple sinatra app with a basic form and test suite included in this repository but buildable thorugh following code examples.
