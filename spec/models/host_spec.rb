require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Host do

  subject { Factory :host }

  before(:each) do
    @valid_attributes = {
      :name => "value for name",
    }
  end

  it "should create a new instance given valid attributes" do
    Host.create!(@valid_attributes)
  end

  it "should touch parent site" do
    subject.update_attribute :site, Factory(:show)

    lambda {
      subject.name = "dummy.fr"
      subject.save
    }.should change(subject.site, :updated_at)
  end

end
