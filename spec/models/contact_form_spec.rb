require 'spec_helper'

describe ContactForm do
  let(:contact_form) { ContactForm.new }
  subject { contact_form }

  context "message is present" do
    before { contact_form.message = 'Test Message' }
    it { should be_valid }
  end

  context "message is missing" do
    before { contact_form.message = nil }
    it { should be_invalid }
  end

end
