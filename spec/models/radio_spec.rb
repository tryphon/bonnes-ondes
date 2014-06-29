require 'spec_helper'

describe Radio do

  describe "#shows" do

    describe "#find_by_slug" do
      let(:radio_show) { Factory :radio_show, :slug => "dummy" }
      let(:show) { radio_show.show }
      let(:radio) { radio_show.radio }

      it "should find Show by RadioShow slug" do
        radio.shows.find_by_slug("dummy").should == show
      end

    end

  end

end
