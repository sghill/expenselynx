When /^I follow the "([^"]*)" link for "(.*)"$/ do |link_name, participant_name|
  within("#" + participant_name) do
    click_link link_name
  end
end

Then /^I should see the edit participant page for "([^"]*)"$/ do |participant_name|
  page.should have_content participant_name
  page.should have_button "Update Participant"
end