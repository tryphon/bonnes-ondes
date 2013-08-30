require 'spec_helper'

describe Public::PagesController do

  let(:theme) { Factory(:template, :slug => Template.default_slug) }


  describe "GET /show" do

    it "should render Page page in a Show site" do
      page = Factory(:page, :show => Factory(:show, :slug => "dummy", :template => theme))
      @request.host = "dummy.bonnes-ondes.fr"
      get :show, :id => page.slug
      response.should be_success
    end

  end

end
