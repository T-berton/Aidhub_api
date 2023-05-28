# require "test_helper"

# class NotificationsChannelTest < ActionCable::Channel::TestCase
#   test "subscribes" do
#     user = User.create!(first_name: "John",last_name: "Doe", email: "john.doe@test.com", password: "password123")
#     request = user.requests.create!(title: "Help needed", description: "I need some help", user_counter: 4)
#     stub_connection current_user: user

#     subscribe(request_id: request.id)
#     assert subscription.confirmed?
#     assert_has_stream "notifications_#{user.id}_#{request.id}"
#   end
# end
