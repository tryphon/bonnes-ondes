require 'spec_helper'

describe ContentHelper do

  let(:content) { AudiobankContent.new }

  describe "audio_player" do

    let(:content_playlist) { "/content.m3u" }

    before(:each) do
      helper.stub :url_for_content => content_playlist
    end

    it "should return an div.player tag" do
      helper.audio_player(content).should have_selector("div.player")
    end

    it "should include a link to mp3 content" do
      helper.audio_player(content).should have_selector("div.player a", :href => content.content_url(:format => :mp3))
    end

  end


end
