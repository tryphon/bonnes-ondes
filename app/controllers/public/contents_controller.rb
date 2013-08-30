class Public::ContentsController < PublicController

  def show
    @episode = current_show.episodes.find_by_slug(params[:episode_id])
    raise ActiveRecord::RecordNotFound unless @episode

    @content = @episode.contents.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @content

    respond_to do |format|
      format.html {
        render_template "content", :episode => @episode, :content => @content
      }
      format.m3u {
        render :text => @content.content_url, :content_type => 'audio/x-mpegurl'
      }
    end
  end

end
