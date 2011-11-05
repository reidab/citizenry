class PersonMailer < ActionMailer::Base
  default :from => SETTINGS['mailer']['default_from']

  def message_from_user(to_person, from_user, message)
    @to_person = to_person
    @from_user = from_user
    @message = message

    subject = t('people.contact.message_subject', :site_name => SETTINGS['organization']['name'], :from => (from_user.name || from_user.email))
    mail(:to => to_person.email, :reply_to => from_user.email, :subject => subject)
  end

end
