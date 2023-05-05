require "test_helper"

class AuthentificationControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def test_authentification_valid_credentials  
    valid_credentials = {
      email: "steve.test@test.com",
      password: "test"
    }
    post '/auth/login', params: valid_credentials
    assert_response :created
    assert_not_nil json_response["token"]
  end 

  def test_authentification_invalid_credential_password
    invalid_credentials = {
      email: "steve.test@test.com",
      password: "invalid"
    }
    post '/auth/login', params: invalid_credentials
    assert_response :unauthorized
  end 

  def test_authentification_invalid_credential_email 
    invalid_credentials = {
      email: "test@invalid.com",
      password: "test"
    }
    post '/auth/login',params: invalid_credentials
    assert_response :unauthorized
  end 


end
