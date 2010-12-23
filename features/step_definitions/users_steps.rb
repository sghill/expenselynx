Given /^that a user with email address "(.*)" has not registered$/ do |email|
  User.find_by_email(email).destroy! unless User.find_by_email(email).nil?
end

Given /^that a user with email address "(.*)" and password "(.*)" exists$/ do |email, password|
  User.create(:email => email, :password => password) if User.find_by_email(email).nil?
end

When /^enter my email address as "(.*)"$/ do |email|
  fill_in "user_email", :with => email
end

When /^enter my password as "(.*)"$/ do |password|
  fill_in "user_password", :with => password
end

When /^enter my password confirmation as "(.*)"$/ do |password|
  fill_in "user_password_confirmation", :with => password
end

When /^click the "(.*)" button$/ do |button_name|
  click_button button_name
end

Then /^I should see my dashboard$/ do
  page.has_content?("Total")
  page.has_link?("Unexpensed")
  page.has_content?("Expensed")
end
