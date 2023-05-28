require 'test_helper'


class ClosureRequestConversationMessage < ActionDispatch::IntegrationTest
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


    test "response to a request with success, removal of the request, the conversation and the messages" do 
        requester = users(:user_1)
        requester_header = get_user_header(requester)
        responder = users(:user_2)
        responder_header = get_user_header(responder)


        post "/requests", params: {
            request:{
            title: "I need help",
            description: "Please help me !!",
            user_id: requester.id 
            }
            }, headers: requester_header

        request = Request.last

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

        post '/messages',params: {
            message:{
                user_id: responder.id,
                conversation_id: conversation.id,
                content: "Hi how are you ?"
            }
        }, headers: responder_header

        assert_response :created
        assert_equal responder.id,json_response["user_id"]

        post '/messages',params: {
            message:{
                user_id: requester.id,
                conversation_id: conversation.id,
                content: "Hi, I am fine thank you"
            }
        }, headers: requester_header

        assert_response :created
        assert_equal requester.id,json_response["user_id"]

        put "/requests/#{request.id}",params: {
            request:{
                status: 'Success'
            }
        }, headers: requester_header
        assert_response :ok
        assert_nil Request.find_by(id: request.id)

        assert_nil Conversation.find_by(id: conversation.id)

        messages = Message.where(conversation_id: conversation.id)
        assert_empty messages
        
            
    end 

end 