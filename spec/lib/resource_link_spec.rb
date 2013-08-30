require 'spec_helper'

describe ResourceLink do

  def link(resource)
    ResourceLink.new(resource)
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
      let(:show) { Factory(:show) }

      it "should be [ show ] " do
        link(show).url_resources.should == [ show ]
      end
    end

    context "when resource is an Episode" do
      let(:episode) { Factory(:episode) }

      it "should be [ show, episode ] " do
        link(episode).url_resources.should == [ episode.show, episode ]
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
      subject.path_resources.should == subject.url_resources[1..-1]
    end

  end

  describe "#path" do

    it "should use url_for with path_resources" do
      subject.stub :path_resources => [ "dummy" ]
      subject.should_receive(:url_for).with(subject.path_resources, {}).and_return("/path/to/resource")
      subject.path.should == "/path/to/resource"
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
