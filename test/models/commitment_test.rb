require 'test_helper'

class CommitmentTest < ActiveSupport::TestCase
  test "saves a valid commitment" do
    assert commitments(:valid_commitment_1).save
  end

  test "does not save an invalid commitment" do
    assert_not commitments(:invalid_commitment).save
  end

  test "does not save a live commitment with joint governance unless it has a joint_governance_description" do
    assert_not commitments(:no_joint_governance_description).save
  end

  test "does save a live commitment with joint governance if it does has a joint_governance_description" do
    commitment = commitments(:no_joint_governance_description)
    commitment.joint_governance_description = 'a description'
    assert commitment.save
  end

  test "sets joint_governance_description to blank if it does not have a joint governance manager" do
    commitment = commitments(:valid_commitment_1)
    assert commitment.save
    assert_not commitment.joint_governance_description.blank?
    commitment.managers = [managers(:indigenous)]
    assert commitment.save
    assert commitment.reload.joint_governance_description.blank?
  end
end
