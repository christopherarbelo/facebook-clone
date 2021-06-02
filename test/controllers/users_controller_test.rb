require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get friends" do
    get users_friends_url
    assert_response :success
  end
end
