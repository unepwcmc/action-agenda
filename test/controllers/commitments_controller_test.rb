require 'test_helper'

class CommitmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should GET index" do
    get commitments_url
    assert_response :success
  end

  test "should GET not found on bad id" do
    commitment = commitments(:valid_commitment_1)
    get commitment_url(1111)
    assert_response :not_found
  end

  test "should GET show" do
    get commitment_url(commitments(:valid_commitment_1).id)
    assert_response :success
  end

  test "should GET new" do
    sign_in users(:user_1)
    get new_commitment_url(criterium_id: criteria(:valid_criterium_without_commitment).id)
    assert_response :success
  end

  test "should not GET new without a criterium_id" do
    sign_in users(:user_1)
    get new_commitment_url
    assert_redirected_to new_criterium_path
  end

  test "should not GET new if the criterium_id matches a different criterium" do
    sign_in users(:user_1)
    commitment_with_criterium = commitments(:valid_commitment_1)
    get new_commitment_url(criterium_id: commitment_with_criterium.criterium_id)
    assert_redirected_to new_criterium_path
  end

  test "should not create a new commitment without a name attribute" do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    invalid_params = {
      commitment: {
        description: "a commitment without a name"
      }
    }
    post commitments_url(params: invalid_params), as: :json
    assert_response :unprocessable_entity
    assert JSON.parse(response.body)["errors"].keys.include?("name")
    assert commitment_count_at_start == Commitment.count
  end

  test "should POST create a new draft commitment with a name" do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    valid_params = {
      commitment: {
        name: "a name"
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :success
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == "draft"
  end

  test "should save commitment as draft and return errors if attempt to create a live commitment fails" do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    valid_params = {
      commitment: {
        name: "a name",
        state: "live"
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :unprocessable_entity
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == "draft"
    assert JSON.parse(response.body).dig("errors").count > 1
  end

  test "should save a live commitment with valid params and return success" do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    valid_params = {
      commitment: {
        latitude: 21.23,
        longitude: 12.214,
        current_area_ha: 4,
        committed_year: 2020,
        implementation_year: 2025,
        name: "a name",
        description: "a description",
        duration_years: 5,
        stage: "Implemented",
        responsible_group: "a name",
        state: "live",
        country_ids: [countries(:hungary).id],
        action_ids: [actions(:species_management).id],
        threat_ids: [threats(:pollution).id],
        manager_ids: [managers(:indigenous).id],
        objective_ids: [objectives(:sustainable_use).id],
        links_attributes: [
          {
            url: "url",
            name: "link name"
          }
        ]
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :success
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == "live"
  end
  
  test "should GET edit" do
    sign_in users(:user_1)
    commitment = commitments(:valid_commitment_1) 
    get edit_commitment_url(commitment)
    assert_response :success
  end

  test "should PUT update a commitment" do
    sign_in users(:user_1)
    new_description = "a new description"
    commitment = commitments(:valid_commitment_1)
    assert commitment.description != new_description 
    put commitment_url(commitment, params: { commitment: { description: new_description }}), as: :json
    assert_response 204
    assert commitment.reload.description == new_description
  end

  test "should destroy a commitment" do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    commitment = commitments(:valid_commitment_1)
    delete commitment_url(commitment), as: :json
    assert_response 204
    assert Commitment.count == commitment_count_at_start - 1
  end

  test "GET edit should redirect to sign in unless signed in" do
    commitment = commitments(:valid_commitment_1) 
    get edit_commitment_url(commitment)
    assert_redirected_to new_user_session_path
  end

  test "GET new should redirect to sign in unless signed in" do
    get new_commitment_url
    assert_redirected_to new_user_session_path
  end

  test "PUT update should redirect to sign in unless signed in" do
    commitment = commitments(:valid_commitment_1)
    put commitment_url(commitment), as: :json
    assert_response :unauthorized
    assert JSON.parse(response.body).dig('error') == I18n.t('devise.failure.unauthenticated')
  end

  test "POST create should redirect to sign in unless signed in" do
    post commitments_url, as: :json
    assert_response :unauthorized
    assert JSON.parse(response.body).dig('error') == I18n.t('devise.failure.unauthenticated')
  end
end
