require 'test_helper'


class ClosureRequest < ActionDispatch::IntegrationTest
    fixtures :users, :requests, :conversations, :conversation_users

    private 
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

    def respond_to_a_request(request,requester,responder,responder_header)
        post "/conversations",params: {
            conversation:{
                request_id: request.id
            },
            responder_id: responder.id,
            requester_id: requester.id
        }, headers: responder_header

        assert_response :created
        conversation = Conversation.find(json_response["id"])
        assert_equal conversation.id, json_response["id"]
    end 

    test "Closure of a request, and all the conversation after 5 users replied to the request" do
        requester = users(:user_1)
        requester_header = get_user_header(requester)
        
        responder_1 = users(:user_2)
        responder_1_header = get_user_header(responder_1)

        responder_2 = users(:user_3)
        responder_2_header = get_user_header(responder_2)

        responder_3 = users(:user_4)
        responder_3_header = get_user_header(responder_3)

        responder_4 = users(:user_5)
        responder_4_header = get_user_header(responder_4)

        responder_5 = users(:user_6)
        responder_5_header = get_user_header(responder_5)

        post "/requests", params: {
        request:{
        title: "I need help",
        description: "Please help me !!",
        user_id: requester.id 
        }
        }, headers: requester_header

        assert_response :created
        request = Request.find(json_response["id"])

        respond_to_a_request(request,requester,responder_1,responder_1_header)
        respond_to_a_request(request,requester,responder_2,responder_2_header)
        respond_to_a_request(request,requester,responder_3,responder_3_header)
        respond_to_a_request(request,requester,responder_4,responder_4_header)
        respond_to_a_request(request,requester,responder_5,responder_5_header)

        request.reload
        assert_equal true,request.closed

        responder_6 = users(:user_7)
        responder_6_header = get_user_header(responder_6)
        post "/conversations",params: {
            conversation:{
                request_id: request.id
            },
            responder_id: responder_6.id,
            requester_id: requester.id
        }, headers: responder_6_header

        assert_response :unprocessable_entity
    end 
end 