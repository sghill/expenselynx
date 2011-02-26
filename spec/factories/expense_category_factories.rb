Factory.define :expense_category do |c|
  c.name "Business Meals"
end

Factory.define :user_store_expense_category do |usec|
  usec.user { |u| u.association(:sara) }
  usec.store { |s| s.association(:chipotle) }
end