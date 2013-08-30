class Public::PagesController < PublicController

  def show
    @page = current_show.pages.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @page

    render_template "page", :page => current_show.pages.find_by_slug(params[:id])
  end

end
