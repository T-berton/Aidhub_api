# require 'test_helper'
# require 'sidekiq/testing'
# Sidekiq::Testing.fake!


# # Test the entire process from the creation of
# # a request to the response from a user and the creation of a conversation between the two users.
# class RepublishTest < ActionDispatch::IntegrationTest

#         def setup
#           Sidekiq::Worker.clear_all
#         end
#         test "check if the job is executed if the request has 5 responders and is closed for more than 24 hours and not yet fulfilled" do 
#             requester = User.create!(first_name: "John",last_name: "Requester", email: "adsqdq@test.com",password: "resquester123")
#             request = requester.requests.create!(title: "Help needed", description: "I need some help", closed: false, user_counter: 4)
            
#             responder = User.create!(first_name: "Steve",last_name: "Responder", email: "qsddqs@test.com",password: "responder123")
#             post "/auth/login",params:{
#               email: responder.email,
#               password: responder.password
#             }
#             assert_response :created
#             assert_not_nil json_response["token"]
#             responder_token = json_response["token"]
#             responder_header = {'Authorization' => "Bearer #{responder_token}"}
        
#             post "/conversations",params: {
#               conversation:{
#                 request_id: request.id
#               },
#               requester_id: requester.id,
#               responder_id: responder.id
#             }, headers: responder_header
        
#             assert_response :created
#             request.reload
#             assert_equal true, request.closed
              
#             assert_equal 1,Sidekiq::Worker.jobs.size
#             job = Sidekiq::Worker.jobs.first
#             assert_equal 24.hours.from_now.to_i,job['at'].to_i
#             assert_equal 'RepublishAlertJob',job['class']
            

#           end

    
# end