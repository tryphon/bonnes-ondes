class Admin::PostsController < AdminController

  belongs_to :show, :finder => :find_by_slug

  def slug
    @slug = Slug.slugify(params[:name], Post.slug_length)
  end

end
