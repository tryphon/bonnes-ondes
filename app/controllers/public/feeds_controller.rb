class Public::FeedsController < PublicController

  respond_to :xml

  def show
    if current_show
      render :content_type => "application/rss+xml"
    else
      render_not_found
    end
  end

end
