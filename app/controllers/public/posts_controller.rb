class Public::PostsController < PublicController

  def show
    render_template "post", :post => current_show.posts.find_by_slug(params[:id])
  end

end
