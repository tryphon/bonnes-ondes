class Admin::ImagesController < AdminController
  belongs_to :show

  protected

  def collection
    @images = end_of_association_chain.paginate(:page => params[:page])
  end

end
