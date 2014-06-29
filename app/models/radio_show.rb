class RadioShow < ActiveRecord::Base
  belongs_to :radio
  belongs_to :show

  validates_presence_of :radio_id, :show_id
  validates_uniqueness_of :slug, :scope => :radio_id

  def define_default_slug
    self.slug ||= show.try :slug
  end
  before_validation :define_default_slug

end
