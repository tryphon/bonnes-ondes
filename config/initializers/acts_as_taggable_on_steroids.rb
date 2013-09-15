require 'acts_as_taggable_on_steroids'
require 'tag_list'
require 'tagging'
require 'tag'

class TagList
  def self.returning(instance, &block)
    instance.tap(&block)
  end
end

class Tag
  attr_accessible :name
end
