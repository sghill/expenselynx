Given /^I have an unexpensed receipt from a new store$/ do
  Receipt.create(:purchase_date => 1.day.ago, 
                 :total => 2.50, 
                 :user => User.find_by_email("chuck@example.com"),
                 :store_name => DateTime.now.to_s,
                 :expensable => true)
end

Then /^I should see "([^"]*)" in the "([^"]*)" column$/ do |expected_value, css_class|
  find(:css, ".#{css_class}").should have_content expected_value
end