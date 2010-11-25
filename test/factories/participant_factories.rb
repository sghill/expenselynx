Factory.define :participant do |p|
  p.name 'Charles Barkley'
  p.user {|u| u.association(:sara)}
end