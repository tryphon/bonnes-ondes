cache [ :feed, @show ] do
  xml.rss :version => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  	xml.channel do
  		xml.title @show.name

      xml.comment! @show.podcast_comment unless @show.podcast_comment.blank?
  		xml.description textilize_in_text(@show.description)
  		xml.link show_url(@show)
      xml.atom :link, :href => podcast_show_url(@show), :rel => "self", :type => "application/rss+xml"

  		xml.lastBuildDate @show.last_update_at.to_formatted_s(:rfc822)

  		xml.language "fr"

  		xml.itunes :summary, textilize_in_text(@show.description)
  		xml.itunes :category, :text => @show.category
      xml.itunes :explicit, "clean"
      xml.itunes :owner do
        xml.itunes :email, @show.contact_email
      end

  		if @show.logo
        url_format = [:jpg, :png].include?(@show.logo.content.format) ? @show.logo.content.format : :jpg
    		xml.itunes :image, :href => @show.logo.content.thumb("1400x1400>").url(:format => url_format)
  		end

      items_for_feed(@show).each do |item|
        cache [ :feed, item ] do
          if Content === item
            xml << render(:partial => "feed_content", :object => item)
          else
           xml << render(:partial => "feed_post", :object => item)
          end
        end
      end
  	end
  end
end
