class Audiobank::Document

  attr_accessor :id, :download_count, :description, :length, :title, :cast, :upload

  def attributes=(attributes)
    attributes.each { |k,v| send "#{k}=", v }
  end

  def initialize(attributes = {})
    self.attributes = attributes
  end

end
