class CreateRadioShows < ActiveRecord::Migration
  def change
    create_table :radio_shows do |t|
      t.string :slug
      t.belongs_to :radio
      t.belongs_to :show

      t.timestamps
    end
  end
end
