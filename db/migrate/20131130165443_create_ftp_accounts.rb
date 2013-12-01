class CreateFtpAccounts < ActiveRecord::Migration
  def up
    create_table :ftp_accounts do |t|
      t.string :userid
      t.string :passwd

      t.integer :uid
      t.integer :guid

      t.string :homedir
      t.string :shell

      t.belongs_to :template
      t.belongs_to :user

      t.timestamps
    end

    FtpAccount.reset_column_information
    User.find_each { |u| FtpAccount.associated(u).each &:save! }
  end

  def down
    drop_table :ftp_accounts
  end
end
