require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def test_index 
    get users_url, headers: authenticated_header
    assert_response :success
    assert_equal User.count, json_response.length
  end 

  def test_index_unautorized
    get users_url
    assert_response :unauthorized
  end 

  def test_show 
    user = users(:user_1)
    get user_url(user), headers: authenticated_header
    assert_response :success
    assert_equal user.id, json_response["id"]
  end 

  def test_show_unauthorized
    user = users(:user_1)
    get user_url(user)
    assert_response :unauthorized
  end 

  def test_create 
    post_params = {
      user: {
        first_name: "Test1",
        last_name: "Test2",
        email: "test1@test2.com",
        password: "testcreate"
      }
    }
    assert_difference "User.count",1 do 
      post users_url, params: post_params
    end 
    assert_response :created
    assert_not_nil json_response['token']

  end 

  def test_update 
    user = users(:user_1)
    put_params = {
      user: {
        first_name: "Test_Update"
      }
    }
    put user_url(user), params: put_params, headers: authenticated_header
    assert_response :success
    assert_equal "Test_Update", json_response['first_name']
  end 

  def test_update_unauthorized
    user = users(:user_1)
    put_params = {
      user: {
        first_name: "Test_Update"
      }
    }
    put user_url(user), params: put_params
    assert_response :unauthorized
  end 

  def test_destroy 
    user = users(:user_1)
    assert_difference "User.count", -1 do 
      delete user_url(user),headers: authenticated_header
    end 
    assert_response :success
  end 

  def test_destroy_unauthorized
    user = users(:user_1)
    delete user_url(user)
    assert_response :unauthorized
  end 

end
