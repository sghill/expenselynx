module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the registration page/
      new_user_registration_path
    when /the login page/
      new_user_session_path
    when /the dashboard page/
      root_path
    when /the create new expense report page/
      new_expense_report_path
    when /the expense report page/
      expense_report_path(ExpenseReport.last)
    when /the edit participant page for "(.*)"/
      edit_participant_path(Participant.find_by_name($1))
    when /the new receipt page/
      new_receipt_path
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
