require 'test_helper'

class ManagerTest < ActiveSupport::TestCase
  test "saves a valid manager" do
    assert managers(:indigenous).save
  end

  test "does not save duplicate managers" do
    manager = managers(:indigenous).save
    assert_not Manager.new(name: 'Indigenous peoples').save
  end
end
