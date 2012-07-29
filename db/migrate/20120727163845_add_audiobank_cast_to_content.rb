class AddAudiobankCastToContent < ActiveRecord::Migration
  def self.up
    rename_column :contents, :audiobank_id, :audiobank_cast
    add_column :contents, :audiobank_id, :integer

    add_index :contents, :audiobank_id
    add_index :contents, :audiobank_cast
  end

  def self.down
    rename_column :contents, :audiobank_cast, :audiobank_id
    remove_column :contents, :audiobank_id
  end
end
