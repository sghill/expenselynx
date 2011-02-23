RSpec::Matchers.define :have_key do |key|
  chain(:with_value) {|value| @value = value }

  match do |hash|
    if @value
      hash[key] == @value
    else
      hash.has_key? key
    end
  end

  description do
    "should #{message key}"
  end

  failure_message_for_should do
    "expected hash to #{message key}, but didn't"
  end

  failure_message_for_should_not do
    "expected hash not to #{message key}, but did"
  end

  def message key
    "have key '#{key}'#{@value ? " with value '#{@value}'" : ""}"
  end
end
