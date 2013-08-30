require 'spec_helper'

describe Public::RadioController do

  let(:theme) { Factory(:template, :slug => Template.default_slug) }

  describe "GET /show" do

    it "should render Radio page" do
      pending

      # Follow this unknown (!) process (?!) :
      #
      # Processing Public::RadioController#show (for 0.0.0.0 at 2013-08-30 08:18:29) [GET]
      #   Host Load (0.2ms)   SELECT * FROM "hosts" WHERE ("hosts"."name" = 'dummy.bonnes-ondes.fr') LIMIT 1
      #   Show Load (0.2ms)   SELECT * FROM "shows" WHERE ("shows"."slug" = 'dummy') LIMIT 1
      # Page not found for dummy.bonnes-ondes.fr/
      # Redirected to http://www.bonnes-ondes.fr

      radio = Factory(:radio, :slug => "dummy", :template => theme)
      @request.host = "dummy.bonnes-ondes.fr"
      get :show

      response.should be_success
    end

  end

end
