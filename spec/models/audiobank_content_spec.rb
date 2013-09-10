require 'spec_helper'

describe AudiobankContent do

  subject { Factory :audiobank_content }

  context "when created" do

    subject { Factory.build :audiobank_content }

    it { should validate_presence_of(:audiobank_id) }

    it "should validate the existence of AudioBank document on create" do
      subject.audiobank_project.should_receive(:exists?).with(subject.audiobank_id).and_return(true)
      subject.valid?
    end

    it "should not be valid if AudioBank document doesn't exist" do
      subject.audiobank_project.stub :exists? => false
      subject.should have(1).error_on(:audiobank_id)
    end

    it "should be valid if no AudioBank project is associated" do
      subject.stub :audiobank_project
      subject.should have(1).error_on(:base)
    end
  end

  it "should not validate the existence of Audiobank document on update" do
    subject.stub :audiobank_project => double, :audiobank_id => 1
    subject.audiobank_project.should_not_receive(:exists?)
    subject.valid?
  end

  describe "content_url" do

    it "should use cast_url with specified form" do
      subject.stub :cast_url => "<cast_url>"
      subject.content_url(:format => "<format>").should == "<cast_url>.<format>"
    end

  end

  describe "playlist_url" do

    before(:each) do
      subject.stub :cast_url => "<cast_url>"
    end

    it "should be the cast_url" do
      subject.playlist_url.should == subject.cast_url
    end

  end

  describe "cast_url" do

    it "should have this form : <audiobank_base_url>/casts/<audiobank_cast>" do
      subject.stub :audiobank_base_url => "<audiobank_base_url>", :audiobank_cast => "<audiobank_cast>"
      subject.cast_url.should == "<audiobank_base_url>/casts/<audiobank_cast>"
    end

  end

  it { should validate_numericality_of(:audiobank_id) }

  it { should allow_value("vxoo3iyg").for(:audiobank_cast) }
  it { should_not allow_value("dummy").for(:audiobank_cast) }

  describe "ready?" do

    it "should be ready when audiobank_cast is defined" do
      subject.audiobank_cast = "dummy"
      subject.should be_ready
    end

  end

  describe "update_document" do

    let(:document) { Audiobank::Document.new }

    before(:each) do
      subject.stub :audiobank_project => double
      subject.audiobank_project.stub :document => document
    end

    it "should update cast if available" do
      document.cast = "vxoo3iyg"
      subject.update_document
      subject.audiobank_cast.should == document.cast
    end

    it "should update duration if available" do
      document.length = 178 # seconds
      subject.update_document
      subject.duration.should == 3 # minutes
    end

    it "should not change cast if not available" do
      document.length = nil
      subject.update_document
      subject.audiobank_cast.should be_nil
    end

    it "should not change duration if not available" do
      document.length = nil
      subject.update_document
      subject.duration.should be_nil
    end

    it "should ignore missing document" do
      subject.audiobank_project.stub :document => nil
      lambda {
        subject.update_document
      }.should_not raise_error
    end

    it "should use the specified document if given" do
      subject.update_document Audiobank::Document.new(:length => 120)
      subject.duration.should == 2
    end

    it "should be invoked when save" do
      subject.should_receive(:update_document)
      subject.save
    end

    it "should not be invoked when save when update_document has been already invoked" do
      subject.update_document Audiobank::Document.new
      subject.should_not_receive(:update_document)
      subject.save
    end

  end

  describe "#audiobank_enabled?" do

    it "should be true if audiobank_project is defined" do
      subject.stub :audiobank_project => double
      subject.should be_audiobank_enabled
    end

  end

end
