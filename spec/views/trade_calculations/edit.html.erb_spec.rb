require 'spec_helper'

describe "/trade_calculations/edit" do
  before(:each) do
    render 'trade_calculations/edit'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/trade_calculations/edit])
  end
end
