require 'spec_helper'

describe ResourceLink do

  def link(resource, options = {})
    ResourceLink.new(resource, options)
  end

  subject { link(Show.new(:slug => "dummy")) }

  describe "#hostname" do

    context "without an Host associated to the site resource" do
      it "should use slug resource" do
        link(Show.new(:slug => "dummy")).hostname.should == "dummy.bonnes-ondes.fr"
      end
    end

    context "which an Host associated to the site resource" do
      it "should use Host name" do
        link(Show.new(:host => Host.new(:name => "www.mydomain.com"))).hostname.should == "www.mydomain.com"
      end
    end

  end

  describe "#slug_hostname" do

    it "should use slug host resource and public domain" do
      subject.stub :public_domain => "example.com"
      subject.host_resource.stub :slug => "dummy"

      subject.slug_hostname.should == "dummy.example.com"
    end

  end

  describe "#url" do

    it "should use hostname and path" do
      subject.stub :hostname => "www.mydomain.com"
      subject.stub :path => "/path/to/resource"
      subject.url.should == "http://www.mydomain.com/path/to/resource"
    end

  end

  describe "#url_resources" do

    context "when resource is a Radio" do
      let(:radio) { Factory(:radio) }

      it "should be [ radio ] " do
        link(radio).url_resources.should == [ radio ]
      end
    end

    context "when resource is a Show" do

      context "without current_radio" do
        let(:show) { Factory :show }

        it "should be [ show ]" do
          link(show).url_resources.should == [ show ]
        end
      end

      context "with current_radio" do
        let(:radio_show) { Factory :radio_show }
        let(:show) { radio_show.show }
        let(:radio) { radio_show.radio }

        it "should be [ radio, radio_show ]" do
          link(show, :current_radio => radio).url_resources.should == [ radio, radio_show ]
        end
      end

    end

    context "when resource is an Episode" do
      context "without current_radio" do
        let(:episode) { Factory(:episode) }

        it "should be [ show, episode ] " do
          link(episode).url_resources.should == [ episode.show, episode ]
        end
      end

      context "with current_radio" do
        let(:radio_show) { Factory :radio_show }
        let(:show) { radio_show.show }
        let(:radio) { radio_show.radio }
        let(:episode) { Factory :episode, :show => show }

        it "should be [ radio, radio_show, episode ]" do
          link(episode, :current_radio => radio).url_resources.should == [ radio, radio_show, episode ]
        end
      end
    end

    context "when resource is an Content" do
      let(:content) { Factory(:content) }

      it "should be [ show, episode, content ] " do
        link(content).url_resources.should == [ content.episode.show, content.episode, content ]
      end
    end

    context "when resource is a Page" do
      let(:page) { Factory(:page) }

      it "should be [ show, page ] " do
        link(page).url_resources.should == [ page.show, page ]
      end
    end

    context "when resource is an Post" do
      let(:post) { Factory(:post) }

      it "should be [ show, post ] " do
        link(post).url_resources.should == [ post.show, post ]
      end
    end

  end

  describe "#path_resources" do

    it "should use url_resources without host_resource" do
      subject.stub :url_resources => [ Radio.new, "dummy" ]
      subject.path_resources.should == [ "dummy" ]
    end

  end

  class TestUrlContext
     include ActionDispatch::Routing::UrlFor
     #include ActionController::UrlFor  #requires a request object
     # include ActionController::PolymorphicRoutes
     include Rails.application.routes.url_helpers

     default_url_options[:host] = 'www.example.com'
  end

  describe "#path" do

    it "should use url_for with path_resources" do
      subject.stub :path_resources => [ "dummy" ]
      subject.should_receive(:path_for).with(subject.path_resources, {}).and_return("/path/to/resource")
      subject.path.should == "/path/to/resource"
    end

    let(:url_context) { TestUrlContext.new }

    it "should return an empty path for a Radio" do
      ResourceLink.new(Factory(:radio)).path.should == ""
    end

    it "should return /e/<Show#slug> when a Show is associated to a Radio without a specified slug" do
      radio_show = Factory(:radio_show, :slug => nil)
      ResourceLink.new(radio_show.show, :current_radio => radio_show.radio, :url_context => url_context).path.should == "/e/#{radio_show.show.slug}"
    end

    it "should return /e/<RadioShow#slug> when a Show is associated to a Radio with a specified slug" do
      radio_show = Factory(:radio_show, :slug => "dummy")
      ResourceLink.new(radio_show.show, :current_radio => radio_show.radio, :url_context => url_context).path.should == "/e/dummy"
    end

  end

  describe "#host_resource" do

    it "should return first resource in url_resources" do
      radio = Radio.new
      subject.stub :url_resources => [ radio, "dummy" ]
      subject.host_resource.should == radio
    end

  end

  describe ".site_in_hostname" do

    it "should be nil when no subdomain of public domain" do
      ResourceLink.slug_in_hostname("www.dummy.fr").should be_nil
    end

    it "should be 'dummy' for 'dummy.bonnes-ondes.fr'" do
      ResourceLink.slug_in_hostname('dummy.bonnes-ondes.fr').should == 'dummy'
    end

  end

  describe ".host_resource" do

    it "should find Show with slug used in hostname" do
      show = Factory(:show, :slug => 'dummy')
      ResourceLink.host_resource("dummy.bonnes-ondes.fr").should == show
    end

    it "should find Radio with slug used in hostname" do
      radio = Factory(:radio, :slug => 'dummy')
      ResourceLink.host_resource("dummy.bonnes-ondes.fr").should == radio
    end

    it "should find Show associated to a Host with hostname" do
      show = Factory(:show, :host => Factory(:host, :name => "www.example.com"))
      ResourceLink.host_resource("www.example.com").should == show
    end

    it "should find Radio associated to a Host with hostname" do
      radio = Factory(:radio, :host => Factory(:host, :name => "www.example.com"))
      ResourceLink.host_resource("www.example.com").should == radio
    end

  end

  describe ".show_host?" do

    let(:hostname) { "www.example.com" }

    it "should return true if host_resource is a Show" do
      ResourceLink.should_receive(:host_resource).with(hostname).and_return(Show.new)
      ResourceLink.show_host?(hostname).should be_true
    end

    it "should return false if host_resource isn't a Show" do
      ResourceLink.stub :host_resource => Radio.new
      ResourceLink.show_host?(hostname).should be_false
    end

  end

  describe ".radio_host?" do

    let(:hostname) { "www.example.com" }

    it "should return true if host_resource is a Radio" do
      ResourceLink.should_receive(:host_resource).with(hostname).and_return(Radio.new)
      ResourceLink.radio_host?(hostname).should be_true
    end

    it "should return false if host_resource isn't a Radio" do
      ResourceLink.stub :host_resource => Show.new
      ResourceLink.radio_host?(hostname).should be_false
    end

  end

end
