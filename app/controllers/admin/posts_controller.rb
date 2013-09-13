class Admin::PostsController < AdminController

  belongs_to :show, :finder => :find_by_slug

  def slug
    render :json => {:slug => Slug.slugify(params[:name], Post.slug_length)}
  end

end
