module ApplicationHelper
  
  def boolean_to_check(conditional)
    return conditional ? "&#10003;".html_safe : "&mdash;".html_safe
  end
end
