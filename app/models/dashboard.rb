class Dashboard

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  delegate :shows, :episodes, :templates, :to => :user

  def show_count
    @show_count ||= shows.size
  end

  def show_lasts
    @show_lasts ||= shows.find(:all, :order => "updated_at desc", :limit => 3)
  end

  def episodes_count
    @episodes_count ||= episodes.size
  end

  def episodes_lasts
    @episodes_lasts ||= episodes.sort_by { |e| e.created_at }.first(5).reverse
  end

end
