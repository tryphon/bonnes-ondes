class Public::FeedsController < PublicController

  def show
    if current_show
      render :content_type => "application/rss+xml"
    else
      render_not_found
    end
  end

end
