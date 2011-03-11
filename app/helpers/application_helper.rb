#encoding: utf-8

module ApplicationHelper  
  def boolean_to_check(conditional)
    return conditional ? "✓" : "—"
  end
  
  def separate_links(*links)
    return links.to_a.join(" :: ")
  end
  
  def grid_for(receipts, options = {})
    options.each { |opt| opt = false if opt.nil? }
    render :partial => "receipts/table", :locals => { :receipts => receipts,
                                                      :editable => options[:editable],
                                                      :shows_expense_status => options[:shows_expense_status],
                                                      :shows_export_status => options[:shows_export_status] }
  end
end
