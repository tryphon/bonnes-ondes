require 'spec_helper'

describe Audiobank::Documents do
  
  let(:account) { Audiobank::Account.new "test:dummy" }

  subject { Audiobank::Documents.new account }

  before(:each) do
    FakeWeb.allow_net_connect = false
  end
  
  describe "#create" do

    it "should post to /documents.json the document attributes" do
      account.should_receive(:post).with("/documents.json", :document => { :title => "dummy" })
      subject.create :title => "dummy"
    end

  end
  
end
