xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  if @radio
    xml.tag! 'url' do
      xml.tag! 'loc', radio_url(@radio)
      xml.tag! 'lastmod', @radio.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'weekly'
      xml.tag! 'priority', '1'
    end
  end

  for show in @shows do
    xml.tag! 'url' do
      xml.tag! 'loc', show_url(show)
      xml.tag! 'lastmod', show.last_update_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'weekly'
      xml.tag! 'priority', '1'
    end

    for episode in show.episodes do
      xml.tag! 'url' do
        xml.tag! 'loc', episode_url(episode)
        xml.tag! 'lastmod', episode.updated_at.strftime("%Y-%m-%d")
        xml.tag! 'changefreq', 'weekly'
        xml.tag! 'priority', '0.5'
      end
    end

    for tag in show.episodes.collect(&:tags).flatten.uniq do
      xml.tag! 'url' do
        xml.tag! 'loc', show_tag_url(show, tag)
        last_episode = tag.taggings.collect(&:taggable).sort_by(&:updated_at).last
        xml.tag! 'lastmod', last_episode.updated_at.strftime("%Y-%m-%d")
        xml.tag! 'changefreq', 'weekly'
        xml.tag! 'priority', '0.3'
      end
    end
  end
end
