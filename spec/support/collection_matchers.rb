RSpec::Matchers.define :be_sorted do
  ASCENDING = lambda do |first, second|
    if @by
      first.send(@by) <=> second.send(@by)
    else
      first <=> second
    end
  end

  chain(:ascending) { @order = ASCENDING }
  chain(:descending) { @order = lambda { |first, second| ASCENDING.call(second, first) } }
  chain(:by) { |by| @by = by }

  match do |list|
    list == list.sort(& @order)
  end

  failure_message_for_should do |list|
    "expected list: #{list.inspect} to be sorted #{ascending_or_descending_message}#{by_message} but was not"
  end

  failure_message_for_should_not do |list|
    "expected list: #{list.inspect} to not be sorted #{ascending_or_descending_message}#{by_message} but was"
  end

  description do
    "be sorted #{ascending_or_descending_message}#{by_message}"
  end

  def by_message
    @by ? " by " + @by.to_s : ""
  end

  def ascending_or_descending_message
    @order == ASCENDING ? "ascending" : "descending"
  end
end
