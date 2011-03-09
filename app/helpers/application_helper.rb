#encoding: utf-8

module ApplicationHelper  
  def boolean_to_check(conditional)
    return conditional ? "✓" : "—"
  end
  
  def separate_links(*links)
    return links.to_a.join(" :: ")
  end
  
  def grid_for(collection)
    return "<table><thead><th>Purchase Date</th><th>Store</th><th>Total</th></thead></table>"
  end
end
