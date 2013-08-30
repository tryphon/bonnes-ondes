class AdminController < InheritedResources::Base

  include AuthenticatedSystem
  before_filter :login_from_cookie, :login_required

  protected

  def begin_of_association_chain
    current_user
  end

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_slug(params[:id]))
  end

end
