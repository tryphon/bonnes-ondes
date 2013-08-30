require 'spec_helper'

describe Public::PostsController do

  let(:theme) { Factory(:template, :slug => Template.default_slug) }


  describe "GET /show" do

    it "should render Post post in a Show site" do
      post = Factory(:post, :show => Factory(:show, :slug => "dummy", :template => theme))
      @request.host = "dummy.bonnes-ondes.fr"
      get :show, :id => post.slug
      response.should be_success
    end

  end

end
