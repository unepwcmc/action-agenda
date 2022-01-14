ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  module MiniTest::Assertions
    ##
    # Fails unless <tt>exp</tt> and <tt>act</tt> are both arrays and
    # contain the same elements.
    #
    #     assert_matched_arrays [3,2,1], [1,2,3]
  
    def assert_matched_arrays exp, act
      exp_ary = exp.to_ary
      assert_kind_of Array, exp_ary
      act_ary = act.to_ary
      assert_kind_of Array, act_ary
      assert_equal exp_ary.sort, act_ary.sort
    end
  end
end
