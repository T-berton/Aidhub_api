require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def test_index 
    get messages_url, headers: authenticated_header
    assert_response :success
    assert_equal Message.count,json_response.length
  end 

  def test_index_unautorized
    get messages_url
    assert_response :unauthorized
  end 

  def test_show
    message = messages(:message_1)
    get message_url(message),headers: authenticated_header
    assert_response :success
    assert_equal message.id, json_response['id']
  end 

  def test_show_unauthorized
    message = messages(:message_1)
    get message_url(message)
    assert_response :unauthorized
  end 

  def test_create 
    conversation = conversations(:conversation_1)
    user = users(:user_2)
    post_params = {
      message: {
          user_id: user.id,
          conversation_id: conversation.id,
          content: "Test message"
      } 
    }
    post messages_url,params: post_params, headers: authenticated_header
    assert_response :created
    message = Message.find(json_response['id'])
    assert_equal user.id, message.user.id
    assert_equal conversation.id,message.conversation.id
  end 

  def test_create_unathorized
    conversation = conversations(:conversation_1)
    user = users(:user_2)
    post_params = {
      message: {
          user_id: user.id,
          conversation_id: conversation.id,
          content: "Test message"
      } 
    }
    post messages_url,params: post_params
    assert_response :unauthorized
  end 

  def test_update 
    message = messages(:message_1)
    put_params = {
      message:{
        content: "updated test"
      }
    }
    put message_url(message),params: put_params, headers: authenticated_header
    assert_response :success
    assert_equal "updated test",json_response["content"]
  end 

  def test_update_unauthorized 
    message = messages(:message_1)
    put_params = {
      message:{
        content: "updated test"
      }
    }
    put message_url(message),params: put_params
    assert_response :unauthorized
  end 

  def test_destroy
    message = messages(:message_1)
    assert_difference "Message.count", -1 do 
      delete message_url(message),headers: authenticated_header
    end 
    assert_response :success
  end 

  def test_destroy_unauthorized
    message = messages(:message_1)
    delete message_url(message)
    assert_response :unauthorized
  end 

end
