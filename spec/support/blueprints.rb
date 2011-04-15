require 'machinist/active_record'

User.blueprint(:colin) do
  email { "colin#{sn}@expenselynx.com" }
  password { "security2" }
end

Store.blueprint(:circuit_city) do
  name { "Circuit City #{sn}" }
end

Receipt.blueprint(:colins_unexpensed_tv_from_circuit_city) do
  purchase_date { 1.day.ago }
  store { Store.make!(:circuit_city) }
  total { 9.16 }
  expensable { true }
  user { User.make(:colin) }
end