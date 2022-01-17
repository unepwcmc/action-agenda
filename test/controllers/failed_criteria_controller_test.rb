require 'test_helper'

class FailedCriteriaControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    criterium = criteria(:no_boundary)
    get failed_criterium_url(criterium)
    assert_response :success
  end
end
