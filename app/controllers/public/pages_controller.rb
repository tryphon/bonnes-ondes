class Public::PagesController < PublicController

  def show
    render_template "page", :page => current_show.pages.find_by_slug(params[:id])
  end

end
