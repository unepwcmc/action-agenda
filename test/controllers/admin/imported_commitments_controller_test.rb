# frozen_string_literal: true

require 'test_helper'

class Admin::ImportedCommitmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # should not get index if not admin
  # should not put update if not admin

  # should get index if admin
  # should put update if admin

  test 'should not get index if not admin' do
    sign_in users(:user_1)
    get admin_imported_commitments_url
    assert_response :found
    assert_redirected_to root_path
  end

  test 'should not put update if not admin' do
  
  end

  test 'should get index if admin' do
  
  end

  test 'should put update if admin' do
  
  end
end
