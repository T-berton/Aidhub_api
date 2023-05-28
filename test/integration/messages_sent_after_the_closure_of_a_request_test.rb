require 'test_helper'


class MessageAfterClosureRequest < ActionDispatch::IntegrationTest
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
    test "sending messages in a conversation after a request has been closed" do 
        requester = users(:user_1)
        requester_header = get_user_header(requester)
        responder = users(:user_2)
        responder_header = get_user_header(responder)

        post "/requests",params: {
            request:{
                user_id: requester.id,
                task_type: "Help please",
                description: "I need your help" 
            }
        },headers: requester_header
        assert_response :created
        request = Request.last
        assert_equal json_response["id"],request.id

        post "/conversations",params: {
            conversation:{
                request_id: Request.last.id
            },
            requester_id: requester.id,
            responder_id: responder.id
        },headers: responder_header

        assert_response :created
        conversation = Conversation.last
        assert_equal json_response["id"],Conversation.last.id

        put "/requests/#{request.id}",params: {
            request:{
                status: 'Success'
            }
        }, headers: requester_header
        assert_response :ok
        assert_nil Request.find_by(id: request.id)

        post '/messages',params: {
            message:{
                user_id: requester.id,
                conversation_id: conversation.id,
                content: "Hi, I am fine thank you"
            }
        }, headers: requester_header

        assert_response :unprocessable_entity


    end 

end 