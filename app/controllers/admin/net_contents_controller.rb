class Admin::NetContentsController < AdminController
  nested_belongs_to :show, :episode, :finder => :find_by_slug

  def create
    create! do |success, failure|
      success.html { redirect_to admin_show_episode_path(@show, @episode) }
    end
  end

  def slug
    render :json => {:slug => Slug.slugify(params[:name])}
  end

end
