RSpec::Matchers.define :include_only do |expected_items|
  match do |actual_items|
    actual_items =~ expected_items 
  end
end
