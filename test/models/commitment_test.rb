require 'test_helper'

class CommitmentTest < ActiveSupport::TestCase
  test "saves a valid commitment" do
    assert commitments(:valid_commitment).save
  end
end
