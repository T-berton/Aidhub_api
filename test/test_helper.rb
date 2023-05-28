ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def json_response 
    JSON.parse(@response.body)
  end  

  def authenticated_header 
    user = users(:user_1)
    token = JsonWebToken.encode(user_id: user.id)
    {'Authorization': "Bearer #{token}"}
  end 

end
