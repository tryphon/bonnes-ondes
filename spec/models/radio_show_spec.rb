require 'spec_helper'

describe RadioShow do

  it { should validate_presence_of(:radio_id) }
  it { should validate_presence_of(:show_id) }

  it do
    Factory(:radio_show)
    should validate_uniqueness_of(:slug).scoped_to(:radio_id)
  end

end
