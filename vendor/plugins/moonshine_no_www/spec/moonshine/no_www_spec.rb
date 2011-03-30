require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

class NoWWWManifest < Moonshine::Manifest::Rails
  include Moonshine::NoWWW
end

describe Moonshine::NoWWW do
  before do
    @manifest = NoWWWManifest.new
  end
  
  describe "without config" do
    describe "regular no_www redirect" do
      pending "Oddities with testing"
    end
  
    describe "ssl no_www redirect" do
      pending "Oddities with testing"
    end
  end
  
  describe "with config" do
    before do
    end

    describe "regular no_www redirect" do
      pending "Oddities with testing"
    end
  
    describe "ssl no_www redirect" do
      pending "Oddities with testing"
    end
  end
end