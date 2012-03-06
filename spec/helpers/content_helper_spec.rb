require 'spec_helper'

describe ContentHelper do

  let(:content) { AudiobankContent.new }

  describe "audio_player" do

    let(:content_playlist) { "/content.m3u" }

    before(:each) do
      helper.stub :url_for_content => content_playlist
    end

    it "should return an div.ui360 tag" do
      helper.audio_player(content).should have_tag("div[class=ui360]")
    end

    it "should include a link to mp3 content" do
      helper.audio_player(content).should have_tag("div.ui360") do
        with_tag("a[href=?]", content.content_url(:format => :mp3))
      end
    end

  end
  

end
