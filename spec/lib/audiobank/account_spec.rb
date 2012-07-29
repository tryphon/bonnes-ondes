require 'spec_helper'

describe Audiobank::Account do

  subject { Audiobank::Account.new("test:dummy") }

  before(:each) do
    FakeWeb.allow_net_connect = false    
  end

  describe "#get" do
    
    it "should send get request to the specified url" do
      FakeWeb.register_uri :get, "http://test:dummy@audiobank.tryphon.org/dummy", :body => 'dummy'
      subject.get("/dummy").body.should == 'dummy'
    end

  end

  describe "#post" do
    
    it "should send post request to the specified url" do
      FakeWeb.register_uri :post, "http://test:dummy@audiobank.tryphon.org/dummy", :body => 'dummy'
      subject.post("/dummy", :key => "value")
      FakeWeb.last_request.body.should == '{"key":"value"}'
    end

  end
  
  describe "#document" do

    let(:json_response) {
      '{"download_count":5,"description":"Dummy","length":1744,"cast":"8a9cygzn","id":721,"upload":"ftp://audiobank.tryphon.org/pqxijmcetmodn25s/","title":"Test"}'
    }

    it "should retrieve invoke http://audiobank.tryphon.org/documents/<id>.json" do
      FakeWeb.register_uri :get, "http://test:dummy@audiobank.tryphon.org/documents/1.json", :body => json_response
      subject.document(1).title.should == "Test"
    end

    it "should return nil if documet is not found" do
      FakeWeb.register_uri :get, "http://test:dummy@audiobank.tryphon.org/documents/1.json", :status => ["404", "Not Found"]
      subject.document(1).should be_nil
    end

  end

end
