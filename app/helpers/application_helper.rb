module ApplicationHelper  
  def boolean_to_check(conditional)
    return conditional ? "&#10003;".html_safe : "&mdash;".html_safe
  end
  
  def separate_links(*links)
    return links.to_a.join(" :: ")
  end
end
