content = feed_content

xml.item do
  title = content.episode.title
  title += " - #{content.name}" if content.episode.contents.many?
  xml.title title

  unless content.episode.tag_list.empty?
    xml.itunes :keywords, content.episode.tag_list.join(',')
    content.episode.tag_list.each do |category|
      xml.category category
    end
  end

  text = textilize_in_text(content.episode.description)
  xml.description text

  xml.itunes :summary, text
  xml.itunes :duration, "#{content.duration}:00" if content.has_duration?
  xml.itunes :explicit, "no"

  # TODO add content length
  if content.available?
    xml.enclosure :url => content_url(content, :format => :mp3), :type => "audio/mpeg", :length => content.length
  end

  xml.guid content_url(content)
  xml.link episode_url(content.episode)

  pub_date = (content.episode.broadcasted_at or content.episode.created_at)
  xml.pubDate pub_date.to_formatted_s(:rfc822)
end
