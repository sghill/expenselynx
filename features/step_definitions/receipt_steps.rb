Given /^"([^"]*)" has created a receipt with participant "([^"]*)"$/ do |user_email, participant_name|
  user = User.find_by_email(user_email)
  participant = Participant.find_or_create_by_name(participant_name, :user => user)
  store = Store.find_or_create_by_name("Chipotle")
  Receipt.create!(:total => Money.new(12.32, "USD"),  :purchase_date => 1.day.ago, 
                  :store => store,                    :participants => [participant],
                  :user => user)
end

Then /^I should see "([^"]*)" in the receipt form$/ do |participant_name|
  find(:css, "#receipt_fields").should have_content participant_name
end

Then /^I should not see "([^"]*)" in the receipt form$/ do |participant_name|
  find(:css, "#receipt_fields").should have_no_content participant_name
end
