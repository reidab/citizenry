require File.dirname(__FILE__) + '/../spec_helper'

describe Authentication do
  it "should be valid" do
    Authentication.new.should be_valid
  end
end


# == Schema Information
#
# Table name: authentications
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  provider            :string(255)
#  uid                 :string(255)
#  info                :text
#  created_at          :datetime
#  updated_at          :datetime
#  access_token        :string(255)
#  access_token_secret :string(255)
#

