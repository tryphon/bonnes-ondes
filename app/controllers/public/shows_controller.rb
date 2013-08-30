class Public::ShowsController < PublicController

  def show
    render_template "show", :show => current_radio.shows.find_by_slug(params[:id])
  end

end
