require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

class GodManifest < Moonshine::Manifest::Rails
  include Moonshine::God
end

describe Moonshine::God do

  before do
    @manifest = GodManifest.new
  end

  describe "with no options" do

    before do
      ENV['RAILS_ENV'] = nil
      @manifest.configure(:deploy_to => '/srv/app')
      @manifest.god
    end

    it "should install god 0.11.0" do
      @manifest.should have_package('god').version('0.11.0')
    end

    it "should default to production" do
      @manifest.files['/etc/god/god.conf'].content.should =~ /production/
    end

    it "should set the RAILS_ROOT" do
      @manifest.files['/etc/god/god.conf'].content.should =~ /\/srv\/app\/current/
    end

  end

  it "allows older versions of god to be defined via options" do
    @manifest.configure(:deploy_to => '/srv/app')
    @manifest.god :version => '0.8.0'

    @manifest.should have_package('god').version('0.8.0')
  end

  it "allows older versions of god to be defined via configure" do
    @manifest.configure(:deploy_to => '/srv/app', :god => {:version => '0.8.0'})
    @manifest.god

    @manifest.should have_package('god').version('0.8.0')
  end

  describe "with options" do

    before do
      ENV['RAILS_ENV'] = 'staging'
      @manifest.god(:log_level => 'info', :log_file => '/tmp/foo.log')
    end

    it "should use the provide log level" do
      @manifest.files['/etc/god/god.conf'].content.should =~ /:info/
    end

    it "should set the environment" do
      @manifest.files['/etc/god/god.conf'].content.should =~ /staging/
    end

  end

end
