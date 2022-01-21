require 'test_helper'

class CommitmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get commitments_url
    assert_response :success
  end

  test "should get not found on bad id" do
    commitment = commitments(:valid_commitment_1)
    get commitment_url(1111)
    assert_response :not_found
  end

  test "should get show" do
    get commitment_url(commitments(:valid_commitment_1).id)
    assert_response :success
  end

  test "should get new" do
    get new_commitment_url
    assert_response :success
  end

  test "should not create a new commitment without a name attribute" do
    commitment_count_at_start = Commitment.count
    invalid_params = {
      commitment: {
        description: 'a commitment without a name'
      }
    }
    post commitments_url(params: invalid_params), as: :json
    assert_response :unprocessable_entity
    assert JSON.parse(response.body)['errors'].keys.include?('name')
    assert commitment_count_at_start == Commitment.count
  end

  test "should create a new draft commitment with a name" do
    commitment_count_at_start = Commitment.count
    valid_params = {
      commitment: {
        name: 'a name'
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :success
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == 'draft'
  end

  test "should save commitment as draft and return errors if attempt to create a live commitment fails" do
    commitment_count_at_start = Commitment.count
    valid_params = {
      commitment: {
        name: 'a name',
        state: 'live'
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :unprocessable_entity
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == 'draft'
    JSON.parse(response.body).dig('errors').count > 1
  end
  
  test "should get edit" do
    commitment = commitments(:valid_commitment_1) 
    get edit_commitment_url(commitment)
    assert_response :success
  end

  test "should update a transaction" do
    new_description = 'a new description'
    commitment = commitments(:valid_commitment_1)
    assert commitment.description != new_description 
    put commitment_url(commitment, params: { commitment: { description: new_description }}), as: :json
    assert_response 204
    assert commitment.reload.description == new_description
  end
end
