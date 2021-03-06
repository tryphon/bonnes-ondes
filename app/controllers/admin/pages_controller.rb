class Admin::PagesController < AdminController
  belongs_to :show, :finder => :find_by_slug

  def slug
    render :json => {:slug => Slug.slugify(params[:name], Page.slug_length)}
  end

  def move_up
    resource.move_higher

    respond_to do |format|
      format.html { redirect_to(admin_show_pages_path(@show)) }
      format.xml  { head :ok }
    end
  end

end
