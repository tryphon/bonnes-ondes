class AdminController < InheritedResources::Base

  include AuthenticatedSystem
  before_filter :login_from_cookie, :login_required

  protected

  def begin_of_association_chain
    current_user
  end

end
