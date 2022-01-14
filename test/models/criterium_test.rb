require 'test_helper'

class CriteriumTest < ActiveSupport::TestCase
  test "should not save criteria with missing attributes" do
    criterium = Criterium.new
    assert_not criterium.save
    assert criterium.errors.count == 3
  end

  test "should be invalid for commitment if it has negative values" do
    assert criteria(:valid_criterium).criteria_valid_for_commitment?
    assert_not criteria(:no_boundary).criteria_valid_for_commitment?
    assert_not criteria(:no_five_year_commitment).criteria_valid_for_commitment?
    assert_not criteria(:no_progress_report).criteria_valid_for_commitment?
    assert_not criteria(:no_cbd_objectives).criteria_valid_for_commitment?
    assert_not criteria(:no_stakeholders).criteria_valid_for_commitment?
  end
end
