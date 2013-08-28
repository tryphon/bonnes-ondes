class Admin::EpisodesController < AdminController
  belongs_to :show

  def slug
    @slug = Slug.slugify(params[:name], Episode.slug_length)
  end

  def index
    @filter = params[:filter] if params[:filter].present?
    @tag = Tag.find(params[:tag]) if params[:tag].present?

    index!
  end

  protected

  def collection
    @episodes = end_of_association_chain

    if @filter == 'without_content'
      @episodes = @episodes.find_all { |episode| episode.contents.select(&:ready?).empty? }
    end

    if @tag
      @episodes = @episodes.find_all { |episode| episode.tags.include? @tag }
    end

    @episodes = @episodes.paginate(:page => params[:page])
  end

end
