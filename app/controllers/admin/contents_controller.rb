class Admin::ContentsController < AdminController
  nested_belongs_to :show, :episode

  def show
    show! do |format|
      format.m3u { render :text => @content.content_url, :content_type => 'audio/x-mpegurl' }
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to admin_show_episode_path(@show, @episode) }
    end
  end
end
