require 'spec_helper'

describe Image do

  subject { Factory :image }

  it "should touch parent Show" do
    lambda {
      subject.title = "Dummy"
      subject.save
    }.should change(subject.show, :updated_at)
  end

end
