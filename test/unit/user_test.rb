require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @john = Factory(:user)
  end
  
  test "user should have many receipts" do
    assert @john.receipts.is_a?(Array)
  end
  
  test "user should have many expense reports" do
    assert @john.expense_reports.is_a?(Array)
  end
end
