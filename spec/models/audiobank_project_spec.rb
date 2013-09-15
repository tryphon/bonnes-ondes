require 'spec_helper'

describe AudiobankProject do

  subject { Factory :audiobank_project }

  it { should validate_presence_of(:token) }

  describe "#document" do

    let(:document) { Audiobank::Document.new }

    it "should delegate to audiobank_account" do
      subject.audiobank_account.should_receive(:document).with(1).and_return(document)
      subject.document(1).should == document
    end

  end

  describe "exists?" do

    it "should return true if document is not nil" do
      subject.should_receive(:document).with(1).and_return(double)
      subject.exists?(1).should be_true
    end

    it "should return false if document is nil" do
      subject.should_receive(:document).with(1)
      subject.exists?(1).should be_false
    end

  end

end
