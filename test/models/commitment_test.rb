require 'test_helper'

class CommitmentTest < ActiveSupport::TestCase
  test "saves a valid commitment" do
    assert commitments(:valid_commitment_1).save
  end

  test "does not save an invalid commitment" do
    assert_not commitments(:invalid_commitment).save
  end
end
