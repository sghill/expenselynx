Factory.define :receipt do |r|
  r.store_id {|s| s.association(:target).id}
  r.purchase_date DateTime.now
  r.total 12.31
end

Factory.define :chipotle_burrito, :class => Receipt do |r|
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