require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HeySortyHelpers do
  include HeySortyHelpers
  
  before(:all) do
    # TODO: Get this shit working.
    @params = {}
    
    @controller = ActionController::Base.new
    @controller.stub!(:params).and_return(@params)
    
    @view = ActionView::Base.new
    @view.controller = @controller
    
    @output = @view.sorty(:title)
  end
  
  it "should output a link"
end