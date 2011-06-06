Factory.define :user do |u|
  u.email 'batman@company.com'
  u.password 'mySecretPassword'
end

Factory.define :sara, :class => User do |u|
  u.email 'sara@yahoo.com'
  u.password 'secret45'
end

Factory.define :colin, :class => User do |u|
  u.sequence(:email) { |sn| "colin#{sn}@expenselynx.com" }
  u.password "security2"
end
