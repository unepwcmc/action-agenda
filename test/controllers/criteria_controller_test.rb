require 'test_helper'

class CriteriaControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_criterium_url
    assert_response :success
  end

  test "should create criterium suitable for commitment" do
    stakeholder = stakeholders(:local_communities)
    cbd_objective = cbd_objectives(:conservation_of_biological_diversity)

    valid_params = {
      criterium: {
          boundary: true,
          five_year_commitment: true,
          progress_report: true,
          stakeholder_ids: [stakeholder.id],
          cbd_objective_ids: [cbd_objective]
      }
    }

    post criteria_url(valid_params), as: :json
    assert_response :success
    response_json = JSON.parse(response.body)
    assert(response_json.dig('redirect_path') == new_commitment_path(params: { criterium_id: Criterium.last.id }))
  end

  test "should create criterium unsuitable for commitment" do
    stakeholder = stakeholders(:local_communities)
    cbd_objective = cbd_objectives(:conservation_of_biological_diversity)

    valid_params = {
      criterium: {
          boundary: true,
          five_year_commitment: true,
          progress_report: false,
          stakeholder_ids: [stakeholder.id],
          cbd_objective_ids: [cbd_objective]
      }
    }

    post criteria_url(valid_params), as: :json
    assert_response :success
    response_json = JSON.parse(response.body)
    assert(response_json.dig('redirect_path').include?('ineligible'))
  end

  test "return errors if parameters are invalid" do
    stakeholder = stakeholders(:local_communities)
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

  test "should get ineligible" do
    criterium = criteria(:no_boundary)
    get ineligible_criteria_url(criterium)
    assert_response :success
  end
end
