require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class AstrailsSafeManifest < Moonshine::Manifest
  include Moonshine::AstrailsSafe
  configure :user => 'rails'
end

describe "A manifest with the AstrailsSafe plugin" do
  
  describe "with default options" do
  
    before do
      @manifest = AstrailsSafeManifest.new
      @manifest.astrails_safe
    end
  
    it "should be executable" do
      @manifest.should be_executable
    end
  
    it "should generate a configuration file" do
      @manifest.files['/etc/astrails/safe.conf'].should_not be_nil
    end
    
    it "should backup the database in database.yml" do
      @manifest.files['/etc/astrails/safe.conf'].should_match /database "foo_prod"/
    end
      
    it "should backup the application root" do
      @manifest.files['/etc/astrails/safe.conf'].should_match /archive 'app_root'/
      @manifest.files['/etc/astrails/safe.conf'].should_match /files "\/srv"/
      @manifest.files['/etc/astrails/safe.conf'].should_match /exclude "\/srv\/foo\/shared\/log"/
    end
    
    it "should create a default cron job" do
      @manifest.crons['astrails-safe'].minute.should == 0
      @manifest.crons['astrails-safe'].hour.should == 0
      @manifest.crons['astrails-safe'].month.should == '*'
      @manifest.crons['astrails-safe'].weekday.should == '*'
      @manifest.crons['astrails-safe'].monthday.should == '*'
    end
  end
  
  describe "specifying databases to back up" do
    before do
      @manifest = AstrailsSafeManifest.new
      @manifest.configuration[:application] = "foo"
      @manifest.configuration[:database] = {:adapter => 'mysql', :database => 'foo_prod'}
      @databases = %w[foo_prod other_db one_more]
      @manifest.astrails_safe(:databases => @databases)
    end
    
    it "should backup the specified databases" do
      @databases.each do |db|
        @manifest.files['/etc/astrails/safe.conf'].should_match /database "#{db}"/
      end
    end
  end
  
  describe "specifying paths to be archived" do
    before do
      @manifest = AstrailsSafeManifest.new
      @manifest.configuration[:application] = "foo"
      @manifest.configuration[:database] = {:adapter => 'mysql', :database => 'foo_prod'}
      @manifest.astrails_safe(:archives => [
        {:name => 'site', :files => '/var/www'},
        {:name => 'app', :files => '/srv'}
      ])
    end
    
    it "should backup the specified paths" do
      @manifest.files['/etc/astrails/safe.conf'].should_match /archive 'site'/
      @manifest.files['/etc/astrails/safe.conf'].should_match /files "\/var\/www"/
      @manifest.files['/etc/astrails/safe.conf'].should_match /archive 'app'/
      @manifest.files['/etc/astrails/safe.conf'].should_match /files "\/srv\/foo"/
      @manifest.files['/etc/astrails/safe.conf'].should_not_match /exclude/
    end
  end
    
  describe "specifying a time to run astrails in cron" do
    before do
      @manifest = AstrailsSafeManifest.new
      @manifest.configuration[:application] = "foo"
      @manifest.configuration[:database] = {:adapter => 'mysql', :database => 'foo_prod'}
      @manifest.astrails_safe(:cron => {:monthday => 1})
    end
    
    it "should set the appropriate time" do
      @manifest.crons['astrails-safe'].minute.should == 0
      @manifest.crons['astrails-safe'].hour.should == 0
      @manifest.crons['astrails-safe'].monthday.should == 1
      @manifest.crons['astrails-safe'].month.should == '*'
      @manifest.crons['astrails-safe'].weekday.should == '*'
    end
    
  end
  
  describe "setting s3 credentials" do
    before do
      @manifest = AstrailsSafeManifest.new
      @manifest.configuration[:application] = "foo"
      @manifest.configuration[:database] = {:adapter => 'mysql', :database => 'foo_prod'}
      @manifest.astrails_safe(:s3 => {:key => 's3key', :secret => 's3secret'})
    end
    
    it "should configure s3" do
      @manifest.files['/etc/astrails/safe.conf'].should_match /s3 do/
      @manifest.files['/etc/astrails/safe.conf'].should_match /key "s3key"/
      @manifest.files['/etc/astrails/safe.conf'].should_match /secret "s3secret"/
    end
    
  end
  
end