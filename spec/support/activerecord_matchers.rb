RSpec::Matchers.define :have_error_message do |message|
  @on = :base
  chain(:on) {|on| @on = on}
  match do |model|
    errors = model.errors[@on] and errors.include? message
  end

  failure_message_for_should do |model|
"""
expected model to have error message '#{message}' on '#{@on}' but didn't. Had:
#{model.errors[@on].inspect}

"""
  end
end
