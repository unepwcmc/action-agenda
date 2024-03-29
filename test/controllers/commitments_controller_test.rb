# frozen_string_literal: true

require 'test_helper'

class CommitmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should GET index' do
    get commitments_url
    assert_response :success
  end

  test 'should GET not found on bad id' do
    commitment = commitments(:published_cfn_commitment_1)
    get commitment_url(1111)
    assert_response :not_found
  end

  test 'should GET show' do
    get commitment_url(commitments(:published_cfn_commitment_1).id)
    assert_response :success
  end

  test 'should GET new' do
    sign_in users(:user_1)
    get new_commitment_url(criterium_id: criteria(:valid_criterium_without_commitment).id)
    assert_response :success
  end

  test 'should not GET new without a criterium_id' do
    sign_in users(:user_1)
    get new_commitment_url
    assert_redirected_to new_criterium_path
  end

  test 'should not GET new if the criterium_id is already associated with a commitment' do
    sign_in users(:user_1)
    commitment_with_criterium = commitments(:published_cfn_commitment_1)
    get new_commitment_url(criterium_id: commitment_with_criterium.criterium_id)
    assert_redirected_to new_criterium_path
  end

  test 'should not create a new commitment without a name attribute' do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    criterium = criteria(:valid_criterium_without_commitment)
    criterium.manager = managers(:indigenous)
    criterium.save
    invalid_params = {
      commitment: {
        description: 'a commitment without a name',
        criterium_id: criterium.id
      }
    }
    post commitments_url(params: invalid_params), as: :json
    assert_response :unprocessable_entity
    assert JSON.parse(response.body)['errors'].include?('name')
    assert commitment_count_at_start == Commitment.count
  end

  test 'should POST create a new draft commitment with a name' do
    sign_in users(:user_1)
    criterium = criteria(:valid_criterium_without_commitment)
    criterium.manager = managers(:indigenous)
    criterium.save
    commitment_count_at_start = Commitment.count
    valid_params = {
      commitment: {
        name: 'a name',
        criterium_id: criterium.id
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :success
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == 'draft'
  end

  test 'should save commitment as draft if attempt to create a live commitment fails' do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    criterium = criteria(:valid_criterium_without_commitment)
    manager = managers(:indigenous)
    criterium.manager = manager
    criterium.save
    valid_params = {
      commitment: {
        name: 'a name',
        state: 'live',
        criterium_id: criterium.id
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :success
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == 'draft'
  end

  test 'should save a live commitment with valid params and return success' do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    criterium = criteria(:valid_criterium_without_commitment)
    criterium.manager = managers(:indigenous)
    criterium.save
    valid_params = {
      commitment: {
        latitude: 21.23,
        longitude: 12.214,
        current_area_ha: 4,
        committed_year: 2020,
        implementation_year: 2025,
        name: 'a name',
        description: 'a description',
        duration_years: 5,
        stage: 'Implemented fully',
        responsible_group: 'a name',
        state: 'live',
        manager_ids: [managers(:indigenous).id],
        country_ids: [countries(:hungary).id],
        action_ids: [actions(:species_management).id],
        threat_ids: [threats(:pollution).id],
        objective_ids: [objectives(:sustainable_use).id],
        criterium_id: criterium.id,
        links_attributes: [
          {
            url: 'url',
            name: 'link name'
          }
        ]
      }
    }
    post commitments_url(params: valid_params), as: :json
    assert_response :success
    assert Commitment.count == commitment_count_at_start + 1
    assert Commitment.last.state == 'live'
  end

  test 'should GET edit' do
    sign_in users(:user_1)
    commitment = commitments(:published_cfn_commitment_1)
    get edit_commitment_url(commitment)
    assert_response :success
  end

  test 'should PUT update a commitment' do
    sign_in users(:user_1)
    new_description = 'a new description'
    commitment = commitments(:published_cfn_commitment_1)
    commitment.manager_ids = [managers(:indigenous).id]
    commitment.save
    assert commitment.description != new_description
    put commitment_url(commitment, params: { commitment: { description: new_description } }), as: :json
    assert_response :success
    assert commitment.reload.description == new_description
  end

  test 'should destroy a commitment' do
    sign_in users(:user_1)
    commitment_count_at_start = Commitment.count
    commitment = commitments(:published_cfn_commitment_1)
    delete commitment_url(commitment), as: :json
    assert_response 204
    assert Commitment.count == commitment_count_at_start - 1
  end

  test 'GET edit should redirect to sign in unless signed in' do
    commitment = commitments(:published_cfn_commitment_1)
    get edit_commitment_url(commitment)
    assert_redirected_to new_user_session_path
  end

  test 'GET new should redirect to sign in unless signed in' do
    get new_commitment_url
    assert_redirected_to new_user_session_path
  end

  test 'PUT update should redirect to sign in unless signed in' do
    commitment = commitments(:published_cfn_commitment_1)
    put commitment_url(commitment), as: :json
    assert_response :unauthorized
    assert JSON.parse(response.body).dig('error') == I18n.t('devise.failure.unauthenticated')
  end

  test 'POST create should redirect to sign in unless signed in' do
    post commitments_url, as: :json
    assert_response :unauthorized
    assert JSON.parse(response.body).dig('error') == I18n.t('devise.failure.unauthenticated')
  end

  test 'should not allow GET edit if commitment does not belong to current_user' do
    sign_in users(:user_2)
    commitment = commitments(:published_cfn_commitment_1)
    get edit_commitment_url(commitment)
    assert_redirected_to root_path
    assert flash.notice == I18n.t('errors.messages.forbidden_resource')
  end

  test 'should not allow PUT update if commitment does not belong to current_user' do
    sign_in users(:user_2)
    new_description = 'a new description'
    commitment = commitments(:published_cfn_commitment_1)
    assert commitment.description != new_description
    put commitment_url(commitment, params: { commitment: { description: new_description } }), as: :json
    assert_response :forbidden
    assert commitment.reload.description != new_description
    assert JSON.parse(response.body).dig('message') == I18n.t('errors.messages.forbidden_resource')
  end

  test 'should not allow DELETE destroy if commitment does not belong to current_user' do
    sign_in users(:user_2)
    commitment_count_at_start = Commitment.count
    commitment = commitments(:published_cfn_commitment_1)
    delete commitment_url(commitment), as: :json
    assert_response :forbidden
    assert Commitment.count == commitment_count_at_start
    assert JSON.parse(response.body).dig('message') == I18n.t('errors.messages.forbidden_resource')
  end

  test 'should not return draft commitments in the index' do
    draft_commitment = commitments(:draft_commitment)
    rejected_cfn_commitment = commitments(:rejected_cbd_commitment)

    published_commitments = [
      commitments(:published_cfn_commitment_1),
      commitments(:published_cfn_commitment_2),
      commitments(:published_cbd_commitment)
    ]

    get commitments_url
    assert_response :success

    returned_commitments = JSON.parse(@controller.view_assigns['paginatedCommitments'])['items']
    assert returned_commitments.count == 3
    assert !returned_commitments.pluck('title').include?(draft_commitment.name)
    assert !returned_commitments.pluck('title').include?(rejected_cfn_commitment.name)
    assert returned_commitments.pluck('title').sort == published_commitments.pluck(:name).sort
  end

  test 'GET show should only show draft commitments to the owner' do
    draft_commitment = commitments(:draft_commitment)
    get commitment_url(draft_commitment)
    assert_response :found
    assert_redirected_to commitments_path
  end
end
