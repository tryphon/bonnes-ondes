require 'spec_helper'

describe Public::ShowController do

  let(:theme) { Factory(:template, :slug => Template.default_slug) }

  describe "GET /show" do

    it "should render Show page" do
      show = Factory(:show, :slug => "dummy", :template => theme)
      @request.host = "dummy.bonnes-ondes.fr"
      get :show
      response.should be_success
    end

  end

end
