require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup 
    @user = User.new(
      first_name: "User",
      last_name: "Test",
      email: "user_test@tes.com",
      password: "usertest"
    )
  end 

  test "user should be valid" do 
    assert @user.valid?
  end 

  test "first_name empty" do 
    @user.first_name = ""
    assert_not @user.valid?
  end 
  test "last_name empty" do 
    @user.last_name = ""
    assert_not @user.valid?
  end 
  test "email empty" do 
    @user.email = ""
    assert_not @user.valid?
  end 

  test "password length < 6" do 
    @user.password = "e"*5
    assert_not @user.valid?
  end 



end
