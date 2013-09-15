# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Template do

  subject { Factory :template }

  it { should validate_presence_of(:name).with_message("Le nom doit être renseigné") }

  it { should validate_presence_of(:slug).with_message("Le lien doit être renseigné") }
  it { should allow_value("abcd", "abcd-ef-2010").for(:slug)  }
  it { should_not allow_value("../abcd", "abcd ef", "abcdé", "ABCD-EF").for(:slug) }

  it { should validate_presence_of(:scm_url).with_message("L'URL git doit être renseignée") }

  it "should touch associated Shows" do
    show = Factory(:show, :template => subject)
    subject.reload
    
    lambda {
      subject.touch
      show.reload
    }.should change(show, :updated_at)
  end

end
