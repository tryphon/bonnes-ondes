class Public::SitemapsController < PublicController

  def show
    @shows = current_radio ? current_radio.shows : [ current_show ]
    render :content_type => "text/xml"
  end

end
