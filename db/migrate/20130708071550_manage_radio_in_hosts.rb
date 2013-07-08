class ManageRadioInHosts < ActiveRecord::Migration
  def self.up
    rename_column :hosts, :show_id, :site_id
    add_column :hosts, :site_type, :string
  end

  def self.down
    rename_column :hosts, :site_id, :show_id
    drop_column :hosts, :site_type, :string
  end
end
