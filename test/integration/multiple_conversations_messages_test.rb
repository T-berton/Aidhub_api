require 'test_helper'

class MultipleConversationsTest < ActionDispatch::IntegrationTest
  fixtures :users, :requests, :conversations, :conversation_users

  def get_user_header(user)
    post "/auth/login", params: {
      email: user.email,
      password: "test123"
    }
    assert_response :created
    assert_not_nil json_response["token"]
    token = json_response["token"]
    header = {'Authorization' => "Bearer #{token}"}
    header
  end

  test "user can participate in multiple requests, conversations and send messages" do
    user =  User.create!(first_name: "John",last_name: "Requester", email: "adsqdq@test.com",password: "test123")
    user_header = get_user_header(user)

    other_users = [users(:user_2),users(:user_3)]

    post "/requests",params: {
        request:{
            user_id: user.id,
            task_type: "Help please",
            description: "I need your help" 
        }
    },headers: user_header
    assert_response :created
    request_1 = Request.last
    assert_equal json_response["id"],request_1.id


    other_users.each do |other_user|
        post "/conversations",params: {
            conversation:{
                request_id: request_1.id
            },
            requester_id: user.id,
            responder_id: other_user.id
        },headers: user_header

        assert_response :created
        conversation = Conversation.last
        assert_equal json_response["id"],conversation.id
    end 

    conversations = Conversation.where(request_id: request_1.id)
    assert_equal 2, conversations.count


    conversations.each do |conversation|
        post '/messages',params: {
            message:{
                user_id: user.id,
                conversation_id: conversation.id,
                content: "Hi, I am fine thank you"
            }
        }, headers: user_header

        assert_response :created
        assert_equal user.id,json_response["user_id"]
    end 

    messages = Message.where(user_id: user.id)
    assert_equal 2,messages.count

  end 
end 