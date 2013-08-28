class Admin::AudiobankContentsController < AdminController
  nested_belongs_to :show, :episode

  def create
    create! do |success, failure|
      success.html { redirect_to admin_show_episode_path(@show, @episode) }
    end
  end
end
