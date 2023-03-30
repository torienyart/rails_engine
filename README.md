# Rails Engine

This API was created for users to search and filter data from a set of merchants and their items which can be purchased via invoices. There are a variety of set endpoints for viewing merchant and item data including a few that allow for specified search results via query params. This API was built using strict TDD, according to MVC convention and RESTful routing principles.
  
## Authors
    
  - **Victoria Enyart** 
  
    - [GitHub](https://github.com/torienyart)
    - [LinkedIn](https://www.linkedin.com/in/victoria-enyart-595052155)
    
## Summary
  - [Getting Started](#getting-started)
  - [Running the tests](#running-the-tests)
  - [Reflection](#reflection)
  - [Acknowledgement](#acknowledgement)

## Getting Started

  - Because this app was built as a local exercise in API's, localhost:3000 can be used to view it's endpoints.

### Installing

- Fork and clone this repo
- Run `bundle install`
- Run `rails db:{create,migrate,seed}`
- Run `rails db:schema:dump`

## Running the tests

- `bundle exec rspec` to run the test suite

### Sample of Tests Across the App
  
  - Testing includes coverage of all endpoint with happy and sad path as well as edge cases.

## Reflection
  - Through the creation of this API I was able to learn concepts including serialization, error rescuing, endpoint testing, and testing within postman.
