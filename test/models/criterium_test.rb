require 'test_helper'

class CriteriumTest < ActiveSupport::TestCase
  test "should not save criteria with missing attributes" do
    criterium = Criterium.new
    assert_not criterium.save
    assert criterium.errors.count == 5
  end

  test "should not save with both 'none of the above' other options" do
    criterium = criteria(:invalid_none_of_the_above_options)
    assert_not criterium.save
    assert criterium.errors.count == 2
  end

  test "should be invalid for commitment if it has negative values" do
    assert criteria(:valid_criterium).criteria_valid_for_commitment?
    assert_not criteria(:no_boundary).criteria_valid_for_commitment?
    assert_not criteria(:no_five_year_commitment).criteria_valid_for_commitment?
    assert_not criteria(:no_progress_report).criteria_valid_for_commitment?
    assert_not criteria(:government_stakeholder).criteria_valid_for_commitment?
    assert_not criteria(:no_cbd_objectives).criteria_valid_for_commitment?
  end
end
