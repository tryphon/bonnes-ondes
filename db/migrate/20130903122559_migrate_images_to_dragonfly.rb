class MigrateImagesToDragonfly < ActiveRecord::Migration
  def self.up
    Image.find_each do |image|
      image.content = File.new image.full_filename
      image.save!
    end
  end

  def self.down
  end
end
