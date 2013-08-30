require 'spec_helper'

describe Public::EpisodesController do

  let(:theme) { Factory(:template, :slug => Template.default_slug) }


  describe "GET /show" do

    it "should render Episode page in a Show site" do
      episode = Factory(:episode, :show => Factory(:show, :slug => "dummy", :template => theme))
      @request.host = "dummy.bonnes-ondes.fr"
      get :show, :id => episode.slug
      response.should be_success
    end

    it "should render Episode page in a Radio site" do
      pending

      radio = Factory(:radio, :slug => "dummy", :template => theme)
      episode = Factory(:episode)
      radio.shows << episode.show

      @request.host = "dummy.bonnes-ondes.fr"
      get :show, :show_id => episode.show, :id => episode.slug
      response.should be_success
    end

  end

end
