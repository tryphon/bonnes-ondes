class LiquidTemplate

  attr_accessor :name, :theme

  def initialize(theme, name)
    @theme, @name = theme, name
  end

  def file
    @theme.resources_dir + "#{name}.liquid"
  end

  def liquid_template
    Liquid::Template.parse(file.read)
  end

  def render(view_context, assigns = {})
    Rails.logger.debug("Render #{theme.slug}/#{name}.liquid")

    assigns = assigns.merge("theme" => theme).stringify_keys!

    # Rails.logger.debug("assigns #{assigns.inspect}")
    # Rails.logger.debug("view_context #{view_context.inspect}")

    liquid_template.send(render_method, assigns, :registers => { :file_system => theme.liquid_file_system, :view_context => view_context })
  end

  def render_method
    Rails.env.development? ? :render! : :render
  end

  def ==(other)
    other and theme == other.theme and name == other.name
  end

end
