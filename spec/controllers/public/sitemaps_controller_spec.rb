require 'spec_helper'

describe Public::SitemapsController do

  describe "GET /show" do

    it "should render Show xml sitemap" do
      Factory(:show, :slug => "dummy")
      @request.host = "dummy.bonnes-ondes.fr"
      get :show, :format => :xml
      response.should be_success
    end

  end

end
