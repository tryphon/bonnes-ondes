require 'spec_helper'

describe "/admin/posts/show" do

  before(:each) do
    assigns[:post] = @post = Factory(:post,
      :title => "value for title",
      :slug => "value for slug",
      :description => "value for description"
    )
  end

  it "should render attributes in <p>" do
    # FIXME no wait to render textilize in view spec
    # can't find' ActionView::Helpers::TextHelper::RedCloth
    view.stub :textilize => "textilized_description"

    render
    rendered.should match(/value\ for\ title/)
    rendered.should match(/textilized_description/)
  end
end
