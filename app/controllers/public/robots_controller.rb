class Public::RobotsController < PublicController

  def show
    @shows = current_radio ? current_radio.shows : [ current_show ]
    render :format => "text/plain"
  end

end
