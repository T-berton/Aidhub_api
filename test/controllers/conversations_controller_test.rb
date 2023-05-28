require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end


  def test_index 
    get conversations_url, headers: authenticated_header 
    assert_response :success
    assert_equal Conversation.count,json_response.length 
  end 

  def test_index_unautorized 
    get conversations_url
    assert_response :unauthorized
  end 

  def test_show
    conversation = conversations(:conversation_1)
    get conversation_url(conversation),headers: authenticated_header
    assert_response :success
    assert_equal conversation.id,json_response['id']
  end 

  def test_show_unauthorized 
    conversation = conversations(:conversation_1)
    get conversation_url(conversation)
    assert_response :unauthorized
  end 
 

  def test_create
    user = users(:user_1) 
    user_2 = users(:user_2)
    request = requests(:request_1)
    post_params = {
      conversation: {
        request_id: request.id,
      }, 
      requester_id: user.id,
      responder_id: user_2.id
    }
    post conversations_url, params: post_params, headers: authenticated_header
    assert_response :created
    conversation = Conversation.find(json_response['id'])
    assert_equal request.id,conversation.request.id
  end 

  def test_create_unathorized 
    user = users(:user_1) 
    request = requests(:request_1)
    post_params = {
      conversation: {
        request_id: request.id 
      }
    }
    post conversations_url, params: post_params
    assert_response :unauthorized
  end 

  # def test_update 
  #   conversation = conversations(:conversation_1)
  #   put_params = {
  #     conversation: {
  #       request_id: requests(:request_2).id
  #     }
  #   }
  #   put conversation_url(conversation), params: put_params
  #   assert_response :accepted 
  #   assert_equal requests(:request_2).id,conversation.request_id
  # end

  def test_destroy
    conversation = conversations(:conversation_1)
    user = users(:user_1)
    puts "Before destroy: #{Conversation.count}"
    # Vérifie si la différence de 'Conversation.count' est de -1 après l'exécution du bloc de code
    assert_difference 'Conversation.count', -1 do
      delete conversation_url(conversation),headers: authenticated_header,params:{
        user_id: user.id
      } # Exécute le code pour supprimer la conversation
    end
    puts "After destroy: #{Conversation.count}"
    assert_response :success
  end

  def test_destroy_unauthorized
    conversation = conversations(:conversation_1)
    delete conversation_url(conversation)
    assert_response :unauthorized
  end 
end
