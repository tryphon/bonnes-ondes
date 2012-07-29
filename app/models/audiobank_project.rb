class AudiobankProject < ActiveRecord::Base

  has_one :show

  validates_presence_of :token

  def audiobank_account
    @audiobank_account ||= Audiobank::Account.new(token)
  end

  delegate :document, :to => :audiobank_account

  def exists?(id)
    document(id).present?
  end

end
