require 'spec_helper'

describe "public/feeds/feed_content" do

  let(:content) { Factory(:show).contents.first }

  before do
    # FIXME no helper in view
    view.stub :content_url => "/path/to/content"
  end

  def render_partial
    render :partial => "public/feeds/feed_content", :object => content
  end

  it "should display enclosure with content url if content is available" do
    content.stub :available? => true
    render_partial

    rendered.should have_selector("enclosure", :url => "/path/to/content", :type => "audio/mpeg")
  end

  it "should not display enclosure if content isn't available" do
    content.stub :available? => false

    render_partial
    rendered.should_not have_selector("enclosure")
  end

end
