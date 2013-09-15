module TextileHelper
  def textilize_in_text(content)
    RedCloth.new(content).to_plain
  end

  def textilize(content)
    RedCloth.new(content).to_html.html_safe
  end
end
