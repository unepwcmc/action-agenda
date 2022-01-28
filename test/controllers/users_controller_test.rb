require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should GET dashboard if signed in" do
    sign_in users(:user_1)
    get dashboard_url
    assert_response :success
  end

  test "should not GET dashboard if signed out" do
    get dashboard_url
    assert_redirected_to new_user_session_path
  end
end