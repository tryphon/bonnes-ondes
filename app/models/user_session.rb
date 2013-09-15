class UserSession < UserInterface::UserSession

  def rated_episodes_ids
    @session[:rated_episodes_ids] ||= []
  end

  def rate_episode(episode)
    rated_episodes_ids << episode.id
  end

  def can_rate_episode?(episode)
    not rated_episodes_ids.include? episode.id
  end

end
