class Public::VotesController < PublicController

  def create
    @episode = current_show.episodes.find_by_slug(params[:episode_id])
    if user_session.can_rate_episode?(@episode)
      @episode.rate params[:rating].to_i
      user_session.rate_episode(@episode)
    end
  end

end
