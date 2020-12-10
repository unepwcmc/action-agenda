require 'test_helper'

class CommitmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get commitments_url
    assert_response :success
  end

  test "should get show" do
    get commitment_url(1111)
    assert_response :not_found
  end

  
end
