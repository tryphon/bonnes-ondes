post = feed_post

xml.item do
  xml.title post.title

  text = textilize_in_text(post.description)
  xml.description text
  xml.itunes :summary, text

  xml.guid post_url(post)
  # TODO
  xml.link show_url(post.show)

  xml.pubDate post.created_at.to_formatted_s(:rfc822)
end
