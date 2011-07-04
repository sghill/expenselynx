Given /^that a user with email address "(.*)" and password "(.*)" exists$/ do |email, password|
  if User.find_by_email(email).nil?
    steps %q{And I am on the registration page}
    steps %Q{And I enter my email address as "#{email}"}
    steps %Q{And I enter my password as "#{password}"}
    steps %Q{And I enter my password confirmation as "#{password}"}
    steps %q{And I press "sign up"}
    steps %q{And I follow "sign out"}
  end
end

When /^I enter my email address as "(.*)"$/ do |email|
  fill_in "user_email", :with => email
end

When /^I enter my password as "(.*)"$/ do |password|
  fill_in "user_password", :with => password
end

When /^I enter my password confirmation as "(.*)"$/ do |password|
  fill_in "user_password_confirmation", :with => password
end

Then /^I should see my dashboard$/ do
  page.should have_content("ready to expense")
end

Then /^I should not see a "(.*)" link$/ do |link_name|
  page.should have_no_content(link_name)
end

Then /^I should not see a "(.*)" element$/ do |id|
  page.should have_no_css("#" + id)
end

Given /^I am logged in as "([^\"]*)"$/ do |email|
  if User.find_by_email(email).nil?
    steps %q{And I am on the registration page}
    steps %Q{And I enter my email address as "#{email}"}
    steps %q{And I enter my password as "password"}
    steps %q{And I enter my password confirmation as "password"}
    steps %q{And I press "sign up"}
  else
    steps %q{And I am on the login page}
    steps %Q{And I enter my email address as "#{email}"}
    steps %q{And I enter my password as "password"}
    steps %q{And I press "user_submit"}
  end
end

Then /^I should see the login page$/ do
  page.should have_content("email")
  page.should have_content("password")
  page.should have_content("remember me")
  page.should have_button("sign in")
end
