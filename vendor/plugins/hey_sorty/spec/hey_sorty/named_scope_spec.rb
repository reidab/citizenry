require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Hey Sorty' do
  it "should add a sortable? method to active records which returns false for non sortables" do
    Unsortable.should_not be_sortable
  end
  
  it "should add a sortable? method to active records which returns true for sortables" do
    Sortable.should be_sortable
  end
  
  describe 'Named Scope' do
    before(:each) do
      @params = {}
    end
    
    describe 'Basics' do
      it "should add a named scope called sorty" do
        Sortable.should respond_to(:sorty)
      end
      
      it "should return a named scope" do
        Sortable.sorty(@params).class.should eql(ActiveRecord::NamedScope::Scope)
      end
    end
    
    describe 'Defaults' do
      before(:all) do
        Sortable.delete_all
        @a = Sortable.create :title => 'a'
        @c = Sortable.create :title => 'c'
        @b = Sortable.create :title => 'b'
      end
      
      it "should default to sorting by id asc" do
        Sortable.sorty(@params).should eql([@a, @c, @b])
      end
      
      describe 'User Defined Defaults' do   
        it "should raise an error if the column specified does not exist on the model" do
          lambda { Sortable.sortable(:non_existant) }.should raise_error(HeySorty::InvalidColumnName)
        end
        
        it "should raise an error if the order specified is neither asc or desc" do
          lambda { Sortable.sortable(:title, :fail) }.should raise_error(HeySorty::InvalidOrderValue)
        end
        
        it "should default to ascending order if order isn't set" do
          Sortable.sortable(:title)
          Sortable.sorty(@params).should eql([@a, @b, @c])
        end
             
        it "should default to user defined defaults when set (title asc)" do
          Sortable.sortable(:title, :asc)
          Sortable.sorty(@params).should eql([@a, @b, @c])
        end
        
        it "should default to user defined defaults when set (title desc)" do
          Sortable.sortable(:title, :desc)
          Sortable.sorty(@params).should eql([@c, @b, @a])
        end
      end
    end
    
    describe 'Sorting Using Params' do
      before(:all) do
        Sortable.delete_all
        @a = Sortable.create :title => 'a'
        @c = Sortable.create :title => 'c'
        @b = Sortable.create :title => 'b'
      end
      
      it "should raise an ArgumentError exception if params column name is not an attribute" do
        lambda { Sortable.sorty({ :column => 'fail' }) }.should raise_error(HeySorty::ArgumentError)
      end
      
      it "should raise an error if the sort order is neither asc or desc" do
        lambda { Sortable.sorty({ :column => 'title', :order => 'fail' }) }.should raise_error(HeySorty::ArgumentError)
      end
      
      it "should sort by the params passed into the sorty named scope" do
        Sortable.sorty({ :column => 'title', :order => 'asc' }).should eql([@a, @b, @c])
      end
    end
    
    describe 'Associations' do
      before(:all) do
        Sortable.delete_all
        @jim = User.create :name => 'Jim'
        @jims_sortable = Sortable.create :user => @jim, :title => 'b'
        @matt = User.create :name => 'Matt'
        @matts_sortable = Sortable.create :user => @matt, :title => 'a'
      end
      
      it "should allow an association to be set as the default column" do
        lambda { Sortable.sortable('user.name') }.should_not raise_error(HeySorty::InvalidColumnName)
      end
      
      it "should sort by the users name" do
        Sortable.sortable('user.name', :asc)
        Sortable.sorty(@params).should eql([@jims_sortable, @matts_sortable])
      end
    end
  end
end