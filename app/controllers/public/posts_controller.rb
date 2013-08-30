class Public::PostsController < PublicController

  def show
    @post = current_show.posts.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @post

    render_template "post", :post => @post
  end

end
