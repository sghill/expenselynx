Factory.define :receipt do |r|
  r.store_id {|s| s.association(:chipotle).id}
  r.purchase_date DateTime.now
  r.total 12.31
end