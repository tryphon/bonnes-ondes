require 'spec_helper'

describe "Partial public/feeds/feed_content" do

  before do
    @content = Factory(:show).contents.first
  end

  def render_partial
    render :partial => "public/feeds/feed_content", :object => @content
  end

  it "should display enclosure with content url if content is available" do
    @content.stub!(:available?).and_return(true)
    render_partial

    response.should have_tag("enclosure[url=?][type=audio/mpeg]", template.content_url(@content, :format => :mp3))
  end

  it "should not display enclosure if content isn't available" do
    @content.stub!(:available?).and_return(false)

    render_partial
    response.should_not have_tag("enclosure")
  end

end
