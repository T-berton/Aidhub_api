require 'test_helper'


class RequestConversationTest < ActionDispatch::IntegrationTest
    fixtures :users, :requests, :conversations, :conversation_users

    test "multiple messages sending test in a conversation between two users" do 
        requester = users(:user_1)
        responder = users(:user_2)
        request = requests(:request_1)
        conversation = conversations(:conversation_1)

        post "/auth/login",params:{
            email: requester.email,
            password: "test"
        }
        assert_response :created
        assert_not_nil json_response["token"]
        requester_token = json_response["token"]
        requester_header = {'Authorization' => "Bearer #{requester_token}"}
    
        post "/auth/login",params:{
            email: responder.email,
            password: "test"
        }
        assert_response :created
        assert_not_nil json_response["token"]
        responder_token = json_response["token"]
        responder_header = {'Authorization' => "Bearer #{responder_token}"}

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

        responder_message = Message.find_by(user_id: responder.id, conversation_id: conversation.id, content: "Hi how are you ?")
        requester_message = Message.find_by(user_id: requester.id, conversation_id: conversation.id, content: "Hi, I am fine thank you")
        

        assert_not_nil requester_message
        assert_not_nil responder_message

        assert_equal requester.id, requester_message.user_id
        assert_equal responder.id, responder_message.user_id

        assert_equal conversation.id, requester_message.conversation_id
        assert_equal conversation.id, responder_message.conversation_id

    end 
end 