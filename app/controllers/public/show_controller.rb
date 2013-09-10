class Public::ShowController < PublicController

  before_filter :check_current_show

  def show
    render_template "show", :show => current_show
  end

end
