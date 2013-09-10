module Liquid::ViewSupport

  protected

  def view_context
    @context.registers[:view_context]
  end
  def view
    view_context
  end

end
