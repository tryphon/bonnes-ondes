# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestContent < Content
end

describe Content do

  before do
    @valid_attributes = { :name => "Test", :slug => "test", :episode_id => 0 }
    @content = TestContent.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    @content.should be_valid
  end

  describe "available_end_at" do

    before do
      @content.save!
    end
    
    it "should be nil by default" do
      @content.available_end_at.should be_nil
    end

  end

  describe "available? " do
    
    it "should be true if available_end_at is nil" do
      @content.available_end_at = nil
      @content.should be_available
    end

    it "should be false if available_end_at is in the past" do
      @content.available_end_at = 1.day.ago
      @content.should_not be_available
    end

    it "should be true if available_end_at is in the future" do
      @content.available_end_at = 1.day.from_now
      @content.should be_available
    end
  end

  it { should be_ready }

end

describe Content::LiquidDropClass do
  include ActionController::Assertions::SelectorAssertions

  let(:content) { Content.new }
  subject { content.to_liquid }

  class TestView 
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::CaptureHelper

    attr_accessor :output_buffer
  end

  before(:each) do
    def subject.view
      @view ||= TestView.new
    end
  end

  describe "audio_player" do

    let(:audio_tag) { "<audio/>" }

    before(:each) do
      subject.view.stub :audio_player => audio_tag
    end
    
    it "should use view audio_player method" do
      subject.view.should_receive(:audio_player).with(content)
      subject.audio_player.should == audio_tag
    end

  end
  

end
