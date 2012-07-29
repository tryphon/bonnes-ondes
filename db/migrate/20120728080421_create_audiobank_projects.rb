class CreateAudiobankProjects < ActiveRecord::Migration
  def self.up
    create_table :audiobank_projects do |t|
      t.string :token

      t.timestamps
    end

    add_column :shows, :audiobank_project_id, :integer
  end

  def self.down
    drop_table :audiobank_projects
    remove_column :shows, :audiobank_project_id
  end

end
