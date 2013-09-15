require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do

  before(:each) do
    @post = Factory(:post)
  end

  it "should valid presence of show" do
    @post.show = nil
    @post.should have(1).error_on(:show_id)
  end

  it "should touch parent Show" do
    lambda {
      @post.title = "Dummy"
      @post.save
    }.should change(@post.show, :updated_at)
  end

end
