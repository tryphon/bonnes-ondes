class CreateRadios < ActiveRecord::Migration
  def self.up
    create_table :radios do |t|
      t.string :name
      t.string :slug

      t.text :description

      t.belongs_to :template

      t.timestamps
    end

    create_table :radios_shows, :id => false do |t|
      t.column :radio_id, :int, :null => false
      t.column :show_id, :int, :null => false
    end

    create_table :radios_users, :id => false do |t|
      t.column :radio_id, :int, :null => false
      t.column :user_id, :int, :null => false
    end
  end

  def self.down
    drop_table :radios
    drop_table :radios_shows
    drop_table :radios_users
  end
end
