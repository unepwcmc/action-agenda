require 'test_helper'

class CriteriumTest < ActiveSupport::TestCase
  test "should not save criteria with missing attributes" do
    criterium = Criterium.new
    assert_not criterium.save
    assert criterium.errors.count == 6
  end

  test "should not save with both 'none of the above' other options" do
    criterium = criteria(:invalid_none_of_the_above_options)
    assert_not criterium.save
    assert criterium.errors.count == 2
    assert_matched_arrays criterium.errors.full_messages, [
      I18n.t(:"activerecord.errors.models.criterium.attributes.base.none_of_the_above_option_for_cbd_commitments"),
      I18n.t(:"activerecord.errors.models.criterium.attributes.base.none_of_the_above_option_for_managers")
    ]
  end

  test "should be invalid for commitment if it has negative values" do
    assert criteria(:valid_criterium).criteria_valid_for_commitment?
    assert_not criteria(:no_boundary).criteria_valid_for_commitment?
    assert_not criteria(:no_five_year_commitment).criteria_valid_for_commitment?
    assert_not criteria(:no_progress_report).criteria_valid_for_commitment?
    assert_not criteria(:government_manager).criteria_valid_for_commitment?
    assert_not criteria(:no_cbd_objectives).criteria_valid_for_commitment?
  end

  test "should give the correct failure messages" do
    assert_matched_arrays criteria(:valid_criterium).failure_messages, []
    assert_matched_arrays criteria(:no_boundary).failure_messages, [I18n.t(:"models.criterium.failure_messages.boundary")]
    assert_matched_arrays criteria(:no_five_year_commitment).failure_messages, [I18n.t(:"models.criterium.failure_messages.five_year_commitment")]
    assert_matched_arrays criteria(:no_progress_report).failure_messages, [I18n.t(:"models.criterium.failure_messages.progress_report")]
    assert_matched_arrays criteria(:government_manager).failure_messages, [I18n.t(:"models.criterium.failure_messages.government_managers")]
    assert_matched_arrays criteria(:no_cbd_objectives).failure_messages, [I18n.t(:"models.criterium.failure_messages.no_cbd_objectives")]
  end
end
