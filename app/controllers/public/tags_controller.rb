class Public::TagsController < PublicController

  def index
    @episodes = Episode.sort current_show.episodes
    render_template "search", :show => current_show, :episodes => @episodes, :search => ""
  end

  def show
    @search = params[:id]
    @episodes = Episode.sort(current_show.episodes.find_tagged_with(@search))

    respond_to do |format|
      format.html {
        render_template "search", :show => current_show, :episodes => @episodes, :search => @search
      }
      format.m3u {}
    end
  end

end
