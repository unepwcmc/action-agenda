require 'test_helper'

class CriteriaControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should GET new" do
    sign_in users(:user_1)
    get new_criterium_url
    assert_response :success
  end

  test "should POST create criterium suitable for commitment" do
    sign_in users(:user_1)
    manager = managers(:local_communities)
    cbd_objective = cbd_objectives(:conservation_of_biological_diversity)

    valid_params = {
      criterium: {
          boundary: true,
          five_year_commitment: true,
          progress_report: true,
          manager_ids: [manager.id],
          cbd_objective_ids: [cbd_objective]
      }
    }

    post criteria_url(valid_params), as: :json
    assert_response :success
    response_json = JSON.parse(response.body)
    assert(response_json.dig('redirect_path') == new_commitment_path(params: { criterium_id: Criterium.last.id }))
  end

  test "should POST create criterium unsuitable for commitment" do
    sign_in users(:user_1)
    manager = managers(:local_communities)
    cbd_objective = cbd_objectives(:conservation_of_biological_diversity)

    valid_params = {
      criterium: {
          boundary: true,
          five_year_commitment: true,
          progress_report: false,
          manager_ids: [manager.id],
          cbd_objective_ids: [cbd_objective]
      }
    }

    post criteria_url(valid_params), as: :json
    assert_response :success
    response_json = JSON.parse(response.body)
    assert(response_json.dig('redirect_path').include?('ineligible'))
  end

  test "return errors if parameters are invalid" do
    sign_in users(:user_1)
    manager = managers(:local_communities)
    cbd_objective = cbd_objectives(:conservation_of_biological_diversity)

    invalid_params = {
      criterium: {
        boundary: '',
        five_year_commitment: '',
        progress_report: ''
      }
    }

    post criteria_url(invalid_params), as: :json
    assert_response :unprocessable_entity
    response_json = JSON.parse(response.body)
    assert(response_json.keys.include?('errors'))
    assert(response_json.dig('errors').length == 5)
    assert(response_json.dig('errors').values.flatten.all? {|error_message| error_message.include?('missing') })
  end

  test "should GET ineligible" do
    sign_in users(:user_1)
    criterium = criteria(:no_boundary)
    get ineligible_criteria_url(criterium)
    assert_response :success
  end

  test "GET new should redirect to sign in unless signed in" do
    get new_criterium_url
    assert_redirected_to new_user_session_path
  end

  test "POST create should redirect to sign in unless signed in" do
    post criteria_url, as: :json
    assert_response :unauthorized
    assert JSON.parse(response.body).dig('error') == I18n.t('devise.failure.unauthenticated')
  end
end
