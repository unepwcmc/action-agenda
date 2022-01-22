require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test "saves a valid country" do
    assert countries(:hungary).save
  end

  test "does not save duplicate countries" do
    country = countries(:hungary).save
    assert_not Country.new(name: 'Hungary', iso: 'HU').save
  end
end
