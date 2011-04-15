#encoding: utf-8

Then /^I should have "([^"]*)" in unexpensed spendings$/ do |amount|
  find(:css, '#unexpensed_total').should have_content amount
end

When /^I enter the following receipts:$/ do |receipts|
  click_link 'create_receipt_link' unless find(:css, '#receipt_submit').visible?

  receipts.hashes.each do |receipt|
    fill_in 'receipt_purchase_date', :with => receipt['Date']
    fill_in 'receipt_store_name', :with => receipt['Store']
    fill_in 'receipt_total', :with => receipt['Total'].to_f
    check 'receipt_expensable' if receipt['Expensable?'] == '✓'

    click_button 'receipt_submit'
  end
end

When /^I create an expense report with the following receipts:$/ do |receipts|
  receipts_to_expense = []
  
  click_link 'create expense report'
  
  receipts.hashes.each do |receipt|
    receipts_to_expense << Receipt.where(:purchase_date => receipt['Date'],
                                        :store_id => Store.find_by_name(receipt['Store']).id,
                                        :total => receipt['Total'].to_f).first.id
  end
  
  receipts_to_expense.each do |id|
    check "receipt_#{id}"
  end
  
  click_button 'Create Expense Report'
end


When /^I should see the following recent receipts:$/ do |table|
  table.diff! tableish('#recent_receipts tr', 'td,th')
end
