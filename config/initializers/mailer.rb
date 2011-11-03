SETTINGS['mailer'] ||= {}

SETTINGS['mailer'].each do |key,value|
  ActionMailer::Base.send("#{key}=", value) if ActionMailer::Base.respond_to?("#{key}=")
end
