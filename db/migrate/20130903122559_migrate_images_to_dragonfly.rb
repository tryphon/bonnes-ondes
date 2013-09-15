class MigrateImagesToDragonfly < ActiveRecord::Migration
  def self.up
    Image.find_each do |image|
    	File.open(image.full_filename, "r") do |f|
	      image.content = f
	      image.save!
	    end
    end
  end

  def self.down
  end
end
