class Audiobank::Documents
  
  attr_accessor :account

  def initialize(account)
    @account = account
  end

  delegate :post, :to => :account

  def create(attributes)
    Rails.logger.info "Create AudioBank document : #{attributes.inspect}"
    post "/documents.json", :document => attributes do |response|
      Audiobank::Document.new(response)
    end
  end

end
