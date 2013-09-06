module TextileHelper
  def textilize_in_text(content)
    RedCloth.new(content).to_plain
  end
end
