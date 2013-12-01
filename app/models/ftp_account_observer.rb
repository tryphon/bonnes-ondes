class FtpAccountObserver < ActiveRecord::Observer
   observe :user, :template

   def after_create(user_or_template)
     Rails.logger.debug "Create new FtpAccounts for #{user_or_template}"
     FtpAccount.associated(user_or_template).each(&:save)
   end
end
