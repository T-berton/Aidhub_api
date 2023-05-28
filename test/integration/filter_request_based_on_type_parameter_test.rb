require 'test_helper'


class FilterRequestTypeParameter < ActionDispatch::IntegrationTest
    fixtures :users, :requests, :conversations, :conversation_users
    def get_user_header(user)
        post "/auth/login", params: {
            email: user.email,
            password: "test"
          }
          assert_response :created
          assert_not_nil json_response["token"]
          token = json_response["token"]
          header = {'Authorization' => "Bearer #{token}"}
          header
    end 
    test "searching and filtering request according to the type task parameter" do 
        requester = users(:user_1)
        requester_header = get_user_header(requester)
        requester_2 = users(:user_2)
        requester_2_header = get_user_header(requester_2)

        # Create multiple requests with different task types
    post "/requests", params: {
        request: {
          user_id: requester.id,
          task_type: "Material Needs",
          description: "I need some materials."
        }
      }, headers: requester_header
      assert_response :created
  
      post "/requests", params: {
        request: {
          user_id: requester_2.id,
          task_type: "One Time Task",
          description: "I need help with a one-time task."
        }
      }, headers: requester_2_header
      assert_response :created

      post "/requests", params: {
        request: {
          user_id: requester_2.id,
          task_type: "One Time Task",
          description: "Please help."
        }
      }, headers: requester_2_header
      assert_response :created
  
      # Filter requests by task_type
      get "/requests", params: {task_type: "One Time Task"}, headers: requester_header
      assert_response :ok

      json_response.each do |request|
        assert_equal "One Time Task",request["task_type"]
      end 
        

    end 

end 