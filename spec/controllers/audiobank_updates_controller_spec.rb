require 'spec_helper'

describe AudiobankUpdatesController do

  let(:audiobank_content) { Factory :audiobank_content }
  let(:audiobank_document) { Audiobank::Document.new(:id => 1) }

  describe "POST create" do

    it "should not require authentication" do
      post :create, :document => { :id => 1 }
      response.should be_success
    end

    it "should ignore empty parameters" do
      post :create
      response.should be_success
    end
    
    it "should find AudiobankContent with specified audiobank_id" do
      AudiobankContent.should_receive(:find_by_audiobank_id).with(1).and_return(audiobank_content)
      post :create, :document => { :id => 1 }
    end

    it "should create an Audiobank::Document with received attributes" do
      attributes = { "id" => 1, "title" => "dummy" }
      audiobank_document.tap do |document|
        Audiobank::Document.should_receive(:new).with(attributes).and_return(document)
      end
      post :create, :document => attributes
    end

    it "should update AudiobankContent with Audiobank::Document" do
      AudiobankContent.stub :find_by_audiobank_id => audiobank_content
      Audiobank::Document.stub :new => audiobank_document

      audiobank_content.should_receive(:update_document).with(audiobank_document).and_return do 
        audiobank_content.updated_document = true
        audiobank_content
      end

      post :create
    end

  end
  
end
