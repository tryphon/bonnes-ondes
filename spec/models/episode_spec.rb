require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Episode do

  describe "#audiobank_enabled?" do

    it "should be true if audiobank_project is defined" do
      subject.stub :audiobank_project => double
      subject.should be_audiobank_enabled
    end

  end

end

describe Episode::LiquidDropClass do

  let(:episode) { Episode.new }
  subject { episode.to_liquid }

  describe "#contents" do

    let(:ready_content) { double :ready? => true }

    it "should return only ready contents" do
      episode.stub :contents => [ ready_content, double(:ready? => false) ]
      subject.contents.should == [ ready_content ]
    end

  end

end
