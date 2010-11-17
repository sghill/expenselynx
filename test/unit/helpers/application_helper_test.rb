require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "boolean to check should return html safe check mark for true" do
    html_check_mark = "&#10003;".html_safe
    assert_equal html_check_mark, boolean_to_check(true)
  end
  
  test "boolean to check should return html safe em dash for false" do
    html_em_dash = "&mdash;".html_safe
    assert_equal html_em_dash, boolean_to_check(false)
  end
end