class Admin::ImagesController < AdminController
  belongs_to :show, :finder => :find_by_slug

  protected

  def collection
    @images = end_of_association_chain.paginate(:page => params[:page])
  end

end
