class Admin::PostsController < AdminController

  belongs_to :show

  def slug
    @slug = Slug.slugify(params[:name], Post.slug_length)
  end

end
