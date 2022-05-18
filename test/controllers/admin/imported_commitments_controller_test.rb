# frozen_string_literal: true

require 'test_helper'

class Admin::ImportedCommitmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # should get index if admin
  # should put update if admin

  test 'should not get index if not admin' do
    sign_in users(:user_1)
    get admin_imported_commitments_url
    assert_response :found
    assert_redirected_to root_path
  end

  test 'should not put update if not admin' do
    sign_in users(:user_1)
    commitment = commitments(:rejected_cbd_commitment)
    put admin_imported_commitment_url(commitment, params: { commitment: { cfn_approved: true } }), as: :json
    assert_response :found
    assert_redirected_to root_path
  end

  test 'should get index if admin' do
    sign_in users(:admin_user)
    get admin_imported_commitments_url
    assert_response :ok
  end

  test 'should put update if admin' do
    sign_in users(:admin_user)
    commitment = commitments(:rejected_cbd_commitment)
    put admin_imported_commitment_url(commitment, params: { commitment: { cfn_approved: true } }), as: :json
    assert_response :ok
    commitment.reload
    assert commitment.cfn_approved == true
  end
end
