require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Episode::LiquidDropClass do

  let(:episode) { Episode.new }
  subject { episode.to_liquid }

  describe "#contents" do

    let(:ready_content) { mock :ready? => true }
    
    it "should return only ready contents" do
      episode.stub :contents => [ ready_content, mock(:ready? => false) ]
      subject.contents.should == [ ready_content ]
    end

  end

end

