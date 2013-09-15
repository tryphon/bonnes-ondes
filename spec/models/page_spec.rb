require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do

  before(:each) do
    @page = Factory(:page)
  end

  it "should valid presence of show" do
    @page.show = nil
    @page.should have(1).error_on(:show_id)
  end

  it "should touch parent Show" do
    lambda {
      @page.title = "Dummy"
      @page.save
    }.should change(@page.show, :updated_at)
  end

end
