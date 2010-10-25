#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

stores = Store.create([ { :name => 'Target' }, 
                        { :name => 'Microcenter' },
                        { :name => 'Jewel-Osco' },
                        { :name => 'The Gap' }])

receipts = Receipt.create([{ :store_id => stores.first.id, 
                             :purchase_date => DateTime.now, 
                             :total => 3.74 },
                           { :store_id => stores.first.id,
                             :purchase_date => DateTime.now - 3.days,
                             :total => 21.37 },
                           { :store_id => stores.last.id,
                             :purchase_date => DateTime.now - 2.days,
                             :total => 13.31 }])