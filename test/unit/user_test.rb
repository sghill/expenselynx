require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should have many receipts" do
    user = Factory(:user)
    assert user.receipts.is_a?(Array)
  end
end
