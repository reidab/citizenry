Person.all.each do |person|
  twitter_user = Twitter.user(person.twitter)
  if twitter_user
    person.imported_from_provider = 'twitter'
    person.imported_from_id = twitter_user.id
    puts "#{person.twitter} => #{twitter_user.id}"
    person.save!
  end
end
