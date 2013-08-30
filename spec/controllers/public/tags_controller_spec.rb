require 'spec_helper'

describe Public::TagsController do

  let(:theme) { Factory(:template, :slug => Template.default_slug) }

  describe "GET /show" do

    it "should render episodes with specified tag" do
      episode = Factory(:episode, :show => Factory(:show, :slug => "dummy", :template => theme))
      episode.tag_list << "test"
      @request.host = "dummy.bonnes-ondes.fr"

      get :show, :id => "test"
      response.should be_success
    end

  end

end
