class Public::EpisodesController < PublicController

  def show
    render_template "episode", :episode => current_show.episodes.find_by_slug(params[:id])
  end

end
