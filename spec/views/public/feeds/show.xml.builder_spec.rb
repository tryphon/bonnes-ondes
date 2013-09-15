require 'spec_helper'

describe "public/feeds/show" do

  let!(:show) { assign :show, Factory(:show) }
  let(:contents) { show.contents}

  before do
    view.stub :contents_for_feed => contents

    # FIXME no helper in view
    view.stub :podcast_show_url => "/path/to/feed", :content_url => "/path/to/content"
  end

  it "should display show title" do
    show.stub :name => "dummy"
    render
    response.should have_selector('title', :text => "dummy")
  end

  it "should use helper contents_for_show to known contents to be displayed" do
    view.should_receive(:contents_for_feed).with(show).and_return(contents)
    render
  end

end
