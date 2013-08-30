class Public::StreamsController < PublicController

  def show
    if current_show
      render_template "stream"
    else
      render_not_found
    end
  end

end
