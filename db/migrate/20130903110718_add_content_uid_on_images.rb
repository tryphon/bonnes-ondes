class AddContentUidOnImages < ActiveRecord::Migration
  def self.up
    add_column :images, :content_uid, :string
  end

  def self.down
    remove_column :images, :content_uid
  end
end
