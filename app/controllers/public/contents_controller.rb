class Public::ContentsController < PublicController

  # respond_to :html, :m3u

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
      format.mp3 {
        redirect_to @content.content_url(:format => :mp3)
      }
      format.ogg {
        redirect_to @content.content_url(:format => :ogg)
      }
    end
  end

end
