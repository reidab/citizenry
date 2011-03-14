#--[ Authentication ]-----------------------------------------------------------
Factory.define :authentication do |a|
  a.provider 'test'
  a.uid UUID.generate(:compact)
  a.info :name => 'Test Auth'
end

#--[ Company ]------------------------------------------------------------------
Factory.define :company do |c|
  c.name { Faker::Company.name }
  c.url {|c| "http://#{c.name.gsub(/[^\w]/,'').downcase}.com/" }
  c.address { [ Faker::Address.street_address,
                Faker::Address.secondary_address,
                Faker::Address.city, Faker::Address.us_state, Faker::Address.zip_code
              ].join(', ') }
  c.description { "We #{Faker::Company.bs}." }
end

#--[ Group ]--------------------------------------------------------------------
Factory.define :group do |g|
  g.name { "#{Faker::Address.city} #{Faker::Company.bs.split(' ').last} #{%w(group enthusiasts admirers mongers brigade developers).sample}".titleize }
  g.description {|g|  name_parts = g.name.split(' ')
                      topic = name_parts[-2]
                      city = name_parts[0..-3].join(' ')

                     "Fun with #{topic} in #{city}!" }
  g.url {|g| "http://#{g.name}.org/".gsub(' ','').downcase }
  g.mailing_list {|g| "http://groups.epdx.org/group/#{g.name.split(' ')[0..-2]}".gsub(' ', '').downcase }
  g.meeting_info { "Call #{Faker::PhoneNumber.phone_number} for meeting info." }
end

#--[ Person ]-------------------------------------------------------------------
Factory.define :person do |p|
  p.name { Faker::Name.name }
  p.email { Faker::Internet.email }
  p.url { Faker::Internet.domain_name }
  p.bio { Faker::Lorem.paragraph }
  p.location { Faker::Address.city }
end

#--[ Project ]------------------------------------------------------------------
Factory.define :project do |p|
  p.name { "The #{Faker::Company.catch_phrase} Project".titleize }
  p.url {|p| "http://#{Faker::Internet.domain_name}/#{p.name.split(' ')[1]}".downcase }
  p.description {|p| "We're building #{p.name.split(' ')[1..-2].join(' ')} for #{Faker::Company.catch_phrase}!".capitalize }
end

#--[ Resource ]-----------------------------------------------------------------
Factory.define :resource do |r|
  r.name { Faker::Company.bs.split(' ')[1..2].join(' ') }
  r.url { Faker::Internet.domain_name }
  r.description {|r| "A site that #{ Faker::Company.bs.split(' ').first } #{r.name}" }
  r.category{|r| r.name.split(' ').last }
end

#--[ User ]---------------------------------------------------------------------
Factory.define :user do |u|
  u.email 'test@example.com'
  u.admin false
  u.after_build do |user|
    user.authentications = [ Factory.build(:authentication, :user => user) ]
  end
end

Factory.define :admin_user, :parent => :user do |u|
  u.admin true
end

