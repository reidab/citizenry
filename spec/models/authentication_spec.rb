require 'spec_helper'

describe Authentication do
  let(:email) { "auth@example.com" }
  let(:omniauth) {
    omniauth = {
      "provider"=>"twitter",
      "uid"=>"555",
      "info"=> {
        "nickname"=>"heisenthought",
        "name"=>"Marc Chung",
        "location"=>"San Francisco"
      },
      "credentials" => {
        "token"=>"aksess-token",
        "secret"=>"sekret-token"
      },
      "extra" => {
        "raw_info" => {
          "name" => "Marc Chung",
          "utc_offset" => -9000,
          "is_superman" => true
        }
      }
    }
  }
  let(:auth) { Authentication.create_from_omniauth!(omniauth, :new_user => {:email => email}) }
  let(:user) { User.find_by_email(email) }

  context ".create_from_omniauth" do
    it "should set user_id" do
      auth.user.should == user
      user.should_not be_nil
    end

    it "should set provider" do
      auth.provider.should == omniauth["provider"]
    end

    it "should set uid" do
      auth.uid.should == omniauth["uid"]
    end

    it "should set access_token" do
      auth.access_token.should == omniauth["credentials"]["token"]
    end

    it "should set access_token_secret" do
      auth.access_token_secret.should == omniauth["credentials"]["secret"]
    end

    it "should set info" do
      auth.info[:name].should == omniauth["extra"]["raw_info"]["name"]
      auth.info[:utc_offset].should == omniauth["extra"]["raw_info"]["utc_offset"]
      auth.info[:is_superman].should == omniauth["extra"]["raw_info"]["is_superman"]
    end
  end
end