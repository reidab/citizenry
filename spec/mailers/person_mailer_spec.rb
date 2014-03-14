require 'spec_helper'

describe PersonMailer do
  it "pulls default_from address from settings" do
    PersonMailer.default[:from].should == SETTINGS['mailer']['default_from']
  end

  describe "#message_from_user" do
    let(:user) { Factory.build(:user, :email => 'francis@bacon.localdomain') }
    let(:person) { Factory.build(:person, :email => 'alice@barnham.localdomain') }
    let(:message) { "I forgive you.  I'll be home when I get over this dreaded case of pneumonia." }
    let(:mail) { PersonMailer.message_from_user(person, user, message) }

    it "will be sent to person's email address" do
      mail.to.should == [person.email]
    end

    it "will be addressed from the default from address" do
      pending "No default from address was set, please add one in settings.yml" \
        if SETTINGS['mailer']['default_from'].nil?

      mail.from.should == [SETTINGS['mailer']['default_from']]
    end

    it "will include a reply_to address with user's email address" do
      mail.reply_to.should == [user.email]
    end

    describe "#subject" do
      it "includes the organization's name" do
        with_settings :organization => { :name => 'MyOrg' } do
          mail.subject.should match 'MyOrg'
        end
      end

      context "when from user has a name" do
        before { user.stub(:name).and_return('Francis') }

        it "includes the user's name" do
          mail.subject.should match user.name
        end

        it "doesn't include the user's email address" do
          mail.subject.should_not match user.email
        end
      end

      context "when from user doesn't have a name" do
        before { user.stub(:name).and_return(nil) }

        it "includes the user's email address" do
          mail.subject.should match user.email
        end
      end
    end

    describe "#body" do
      let(:encoded_body) { mail.body.encoded }

      it "includes the from user's email address" do
        encoded_body.should match user.email
      end

      it "includes the message" do
        encoded_body.should match message
      end
    end

  end
end
