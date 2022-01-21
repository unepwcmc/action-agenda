require 'test_helper'

class ThreatTest < ActiveSupport::TestCase
  test "saves a valid threat" do
    assert threats(:pollution).save
  end

  test "does not save duplicate threats" do
    threat = threats(:pollution).save
    assert_not Threat.create(name: 'Pollution').save
  end
end
