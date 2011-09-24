require 'spec_helper'

describe Person do
  describe "when importing photos" do
    it "should not import unless a URL was specified" do
      person = Factory.build(:person)
      person.should_not_receive(:import_photo)

      person.save!
    end

    it "should try to import if a URL was specified" do
      url = "http://mysite.com/heart.png"
      FakeWeb.register_uri(:get, url,
        :status => ["200", "Found"],
        :content_type => "image/jpeg",
        :body => File.read(Rails.root + 'spec/samples/heart.png'))

      person = Factory.build(:person)
      person.photo_import_url = url

      person.should_receive(:import_images).and_return(true)

      person.save!
    end

    it "should display error if URL was invalid" do
      person = Factory.build(:person)
      person.photo_import_url = "\\invalid"

      person.should_not be_valid
      person.errors[:photo_import_url].should be_present
    end

    it "should display error if unable to download from URL" do
      FakeWeb.register_uri(:get, "http://foo", :status => ["404", "Not Found"])

      person = Factory.build(:person)
      person.photo_import_url = "http://foo"

      person.should_not be_valid
      person.errors[:photo_import_url].to_s.should =~ /404/
    end

    it "should display error if importing a zer0-length file" do
      url = "http://mysite.com/zero.png"
      FakeWeb.register_uri(:get, url,
        :status => ["200", "Found"],
        :content_type => "image/jpeg",
        :body => "")

      person = Factory.build(:person)
      person.photo_import_url = url

      person.should_not be_valid
      person.errors[:photo_import_url].to_s.should =~ /0 bytes/
    end

    it "should display error if importing a huge file" do
      url = "http://mysite.com/huge.png"
      FakeWeb.register_uri(:get, url,
        :status => ["200", "Found"],
        :content_type => "image/jpeg",
        :body => ("." * (Person.import_image_from_url_settings[:photo][:maximum_size] + 1)))

      person = Factory.build(:person)
      person.photo_import_url = url

      person.should_not be_valid
      person.errors[:photo_import_url].to_s.should =~ /must be smaller than/
    end

    it "should import if given a valid URL to a working site" do
      url = "http://mysite.com/heart.png"
      FakeWeb.register_uri(:get, url,
        :status => ["200", "Found"],
        :content_type => "image/jpeg",
        :body => File.read(Rails.root + 'spec/samples/heart.png'))

      person = Factory.build(:person)
      person.photo_import_url = url

      person.should be_valid
    end
  end

  describe "when using slugs" do
    before :each do
      DatabaseCleaner.clean
    end

    it "should create a slug when saving a new record" do
      person = Factory.build(:person, :name => "Bob Smith")
      person.slug.should be_nil

      person.save!
      person.slug.should == "bob-smith"
    end

    it "should allow the slug to be overriden" do
      person = Factory.create(:person)

      person.custom_slug = "Bubba Jack"
      person.save!
      person.slug == "bubba-jack"
    end

    it "should not allow duplicate slugs" do
      bob = Factory.create(:person, :name => "Bob Smith")
      bubba = Factory.create(:person, :name => "Bubba Jack")

      bubba.custom_slug = "bob-smith"
      bob.slug.should == bubba.custom_slug

      bubba.should_not be_valid
      bubba.errors[:custom_slug].should_not be_nil
    end
  end
end
