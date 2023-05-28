require 'test_helper'

# Test the entire process from the creation of
# a request to the response from a user and the creation of a conversation between the two users.
class ConversationMessageTest < ActionDispatch::IntegrationTest
        fixtures :users
      
test "create account, sign in user, create a request, respond to the request, create a conversation, message in the conversation between the two users" do

    requester = User.create!(first_name: "John",last_name: "Requester", email: "adsqdq@test.com",password: "resquester123")
    responder = User.create!(first_name: "Steve",last_name: "Responder", email: "qsddqs@test.com",password: "resquester123")

    post "/auth/login",params:{
        email: requester.email,
        password: requester.password
    }
    assert_response :created
    assert_not_nil json_response["token"]
    requester_token = json_response["token"]
    requester_header = {'Authorization' => "Bearer #{requester_token}"}

    post "/auth/login",params:{
        email: responder.email,
        password: responder.password
    }
    assert_response :created
    assert_not_nil json_response["token"]
    responder_token = json_response["token"]
    responder_header = {'Authorization' => "Bearer #{responder_token}"}


    post "/requests", params: {
    request:{
    title: "I need help",
    description: "Please help me !!",
    user_id: requester.id 
    }
    }, headers: requester_header

    assert_response :created
    assert_equal requester.id,json_response["user_id"]

    post "/conversations",params: {
        conversation:{
            request_id: Request.last.id
        },
        requester_id: requester.id,
        responder_id: responder.id
    }, headers: responder_header

    assert_response :created
    conversation = Conversation.find_by(request_id: Request.last.id)
    assert_equal conversation.id, json_response["id"]

    requester_relation = ConversationUser.find_by(user_id: requester.id, conversation_id: conversation.id)
    responder_relation = ConversationUser.find_by(user_id: responder.id, conversation_id: conversation.id)

    assert_not_nil requester_relation
    assert_not_nil responder_relation

    post '/messages',params: {
        message:{
            user_id: responder.id,
            conversation_id: conversation.id,
            content: "Hey, how are you, how can i help you ?"
        }
    },headers: responder_header
    assert_response :created
    assert_equal "Hey, how are you, how can i help you ?",json_response["content"]
    assert_equal responder.id, json_response["user_id"]
    assert_equal conversation.id,json_response["conversation_id"]

end 

end 