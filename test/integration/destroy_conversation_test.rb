require 'test_helper'


class DestroyConversation < ActionDispatch::IntegrationTest
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

    test "destroy conversation as the requester of a request" do
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
                request_id: request.id
            },
            requester_id: requester.id,
            responder_id: responder.id
        },headers: responder_header

        assert_response :created
        conversation = Conversation.last
        assert_equal json_response["id"],conversation.id
        
        delete "/conversations/#{conversation.id}",params: {
            user_id: requester.id
        },headers: requester_header
        assert_response :ok 
        assert_nil Request.find_by(id: request.id)
        assert_nil Conversation.find_by(id: conversation.id)

    end 
    
    test "destroy conversation as a responder of a request" do
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
                request_id: request.id
            },
            requester_id: requester.id,
            responder_id: responder.id
        },headers: responder_header

        assert_response :created
        conversation = Conversation.last
        assert_equal json_response["id"],conversation.id
        
        delete "/conversations/#{conversation.id}",params: {
            user_id: responder.id
        },headers: responder_header
        assert_response :ok 
        assert_not_nil Request.find_by(id: request.id)
        assert_nil Conversation.find_by(id: conversation.id)

    end 

end 