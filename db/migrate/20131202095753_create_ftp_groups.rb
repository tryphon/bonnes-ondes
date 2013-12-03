class CreateFtpGroups < ActiveRecord::Migration
  def up
    # Required by proftpd-mod-mysql
    create_table :ftp_groups do |t|
      t.string :groupname
      t.integer :gid
      t.string :members
    end
  end

  def down
    drop_table :ftp_groups
  end
end
