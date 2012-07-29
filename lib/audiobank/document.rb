class Audiobank::Document

  attr_accessor :id, :download_count, :description, :length, :title, :cast, :upload
  attr_accessor :errors

  def attributes=(attributes)
    attributes.each { |k,v| send "#{k}=", v }
  end

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def errors=(errors)
    @errors = (String === errors ? JSON.parse(errors) : errors)
  end

  def valid?
    errors.blank?
  end

end
