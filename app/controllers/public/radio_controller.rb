class Public::RadioController < PublicController

  def show
    render_template "radio", :radio => current_radio
  end

end
