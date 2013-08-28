class Admin::ShowsController < AdminController

  def destroy
    destroy! do |format|
      format.html { redirect_to admin_path }
    end
  end

  def slug
    @slug = Slug.slugify(params[:name])
  end

end
