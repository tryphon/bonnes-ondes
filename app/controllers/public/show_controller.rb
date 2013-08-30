class Public::ShowController < PublicController

  def show
    render_template "show", :show => current_show
  end

end
