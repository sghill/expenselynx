Factory.define :receipt do |r|
  r.store { |s| s.association(:target) }
  r.purchase_date DateTime.now
  r.total 12.31
end

Factory.define :receipt_with_no_total, :class => Receipt do |r|
  r.store { |s| s.association(:target) }
  r.purchase_date DateTime.now
end

Factory.define :chipotle_burrito, :class => Receipt do |r|
  r.user {|u| u.association(:sara)}
  r.store {|s| s.association(:chipotle)}
  r.purchase_date DateTime.now
  r.total 27.91
end

Factory.define :starbucks_coffee, :class => Receipt do |r|
  r.store_id {|s| s.association(:starbucks).id}
  r.purchase_date DateTime.now
  r.total 6.55
end

Factory.define :best_buy_tv, :class => Receipt do |r|
  r.store_id {|s| s.association(:best_buy).id}
  r.purchase_date DateTime.now
  r.total 1000.77
end

Factory.define :oil_filter, :class => Receipt do |r|
  r.store_id {|s| s.association(:murrays).id}
  r.purchase_date DateTime.now
  r.total 7.91
end

Factory.define :baja_tacos, :class => Receipt do |r|
  r.store_id {|s| s.association(:baja_fresh).id}
  r.purchase_date DateTime.now
  r.total 7.54
end

Factory.define :sara_nachos, :class => Receipt do |r|
  r.store_name "Baja Fresh"
  r.user {|u| u.association(:sara)}
  r.purchase_date "11/06/2010"
  r.total 7.54
end

Factory.define :colins_unexpensed_tv_from_circuit_city, :class => Receipt do |r|
  r.purchase_date 1.day.ago
  r.sequence(:store_name) {|n| "Circuit City #{n}" }
  r.total 9.16
  r.expensable true
  r.user {|u| u.association(:colin)}
end
