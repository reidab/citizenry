FactoryGirl.define do
  #--[ Authentication ]------------------------------------------------------- 
  factory :authentication do
    provider 'open_id'
    uid { UUID.generate(:compact) }
    info :name => 'Test Auth'
  end

  #--[ Company ]------------------------------------------------------------------
  factory :company do 
    name { Faker::Company.name }
    url {|c| "http://#{c.name.gsub(/[^\w]/,'').downcase}.com/" }
    address { [ Faker::Address.street_address,
                  Faker::Address.secondary_address,
                  Faker::Address.city, Faker::Address.us_state, Faker::Address.zip_code
                ].join(', ') }
    description { "We #{Faker::Company.bs}." }
  end

  #--[ Group ]--------------------------------------------------------------------
  factory :group do 
    name { "#{Faker::Address.city} #{Faker::Company.bs.split(' ').last} #{%w(group enthusiasts admirers mongers brigade developers).sample}".titleize }
    description {|g|  name_parts = g.name.split(' ')
                        topic = name_parts[-2]
                        city = name_parts[0..-3].join(' ')

                       "Fun with #{topic} in #{city}!" }
    url {|g| "http://#{g.name}.org/".gsub(' ','').downcase }
    mailing_list {|g| "http://groups.epdx.org/group/#{g.name.split(' ')[0..-2]}".gsub(' ', '').downcase }
    meeting_info { "Call #{Faker::PhoneNumber.phone_number} for meeting info." }
  end

  #--[ Person ]-------------------------------------------------------------------
  factory :person do 
    name { Faker::Name.name }
    email { Faker::Internet.email }
    url { Faker::Internet.domain_name }
    bio { Faker::Lorem.paragraph }
    location { Faker::Address.city }
  end

  #--[ Project ]------------------------------------------------------------------
  factory :project do 
    name { "The #{Faker::Company.catch_phrase} Project".titleize }
    url {|p| "http://#{Faker::Internet.domain_name}/#{p.name.split(' ')[1]}".downcase }
    description {|p| "We're building #{p.name.split(' ')[1..-2].join(' ')} for #{Faker::Company.catch_phrase}!".capitalize }
  end

  #--[ Resource Links ]-----------------------------------------------------------
  factory :resource_link do 
    name { Faker::Company.bs.split(' ')[1..2].join(' ') }
    url { Faker::Internet.domain_name }
    description {|r| "A site that #{ Faker::Company.bs.split(' ').first } #{r.name}" }
    category{|r| r.name.split(' ').last }
  end

  #--[ User ]---------------------------------------------------------------------
  factory :user do 
    email { Faker::Internet.email }
    admin false
    after_build do |user|
      user.authentications = [ FactoryGirl.build(:authentication, :user => user) ]
    end
  end

  factory :admin_user, :parent => :user do 
    admin true
  end

  factory :user_with_new_person, :parent => :user do 
    association :person
  end

  factory :user_with_person, :parent => :user do 
    person {|u| u.association(:person, :reviewed => true) }
  end
end