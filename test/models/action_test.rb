require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  test "saves a valid action" do
    assert actions(:species_management).save
  end

  test "does not save duplicate actions" do
    action = actions(:species_management).save
    assert_not Action.create(name: 'Species Management').save
  end
end
