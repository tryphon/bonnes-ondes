module Liquid::ViewSupport

  protected

  def view_context
    @context.registers[:view_context]
  end

end
