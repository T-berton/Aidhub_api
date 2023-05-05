require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def test_index
    get requests_url,headers: authenticated_header
    assert_response :success
    assert_equal Request.count,json_response.length
  end 

  def test_index_unautorized
    get requests_url
    assert_response :unauthorized
  end 

  def test_show
    request = requests(:request_1)
    get request_url(request), headers: authenticated_header
    assert_response :success
    assert_equal request.id,json_response["id"]
  end

  def test_show_unauthorized
    request = requests(:request_1)
    get request_url(request)
    assert_response :unauthorized
  end 

  def test_create
    user = users(:user_1)
    post_params = {
      request: {
        user_id: user.id,
        task_type: "Other",
        description: "Other TEST"
      }
    }
    post requests_url,params: post_params, headers: authenticated_header
    request = Request.find(json_response["id"])
    assert_equal user.id, request.user.id
  end 

  def test_create_unathorized
    user = users(:user_1)
    post_params = {
      request: {
        user_id: user.id,
        task_type: "Other",
        description: "Other TEST"
      }
    }
    post requests_url,params: post_params
    assert_response :unauthorized
  end 

  def test_update 
    request = requests(:request_1)
    put_params = {
      request: {
        task_type: "Other Test2"
      }
    }
    put request_url(request), params: put_params, headers: authenticated_header
    assert_response :success 
    assert_equal "Other Test2",json_response["task_type"]
  end 

  def test_update_unauthorized
    request = requests(:request_1)
    put_params = {
      request: {
        task_type: "Other Test2"
      }
    }
    put request_url(request), params: put_params
    assert_response :unauthorized 
  end 

  def test_destroy
    request = requests(:request_1)
    assert_difference "Request.count", -1 do 
      delete request_url(request),headers: authenticated_header
    end 
  end 

  def test_destroy_unauthorized
    request = requests(:request_1)
    delete request_url(request)
    assert_response :unauthorized
  end 

end
