require 'test_helper'

class API::V1::CommitmentsControllerTest < ActionDispatch::IntegrationTest
  test "should GET index" do
    get api_v1_commitments_url
    assert_response :success
  end
end