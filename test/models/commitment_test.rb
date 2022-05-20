require 'test_helper'

class CommitmentTest < ActiveSupport::TestCase
  test "saves a valid commitment" do
    commitment = commitments(:published_cfn_commitment_1)
    manager = managers(:indigenous)
    commitment.manager_ids = [manager.id]
    assert commitment.save
  end

  test "does not save an invalid commitment" do
    assert_not commitments(:invalid_commitment).save
  end
end
