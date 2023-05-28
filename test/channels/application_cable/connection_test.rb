require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  test "connects with token" do
    user = User.create!(first_name: "John",last_name: "Doe", email: "john.doe@test.com", password: "password123")
    token = JsonWebToken.encode(user_id: user.id )

    connect "/cable?token=#{token}"

    assert_equal connection.current_user.id, user.id
  end
end
