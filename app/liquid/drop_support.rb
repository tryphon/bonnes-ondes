module Liquid::DropSupport

  protected

  def resolve(object)
    if object.is_a?(Liquid::Drop)
      object.instance_variable_get("@object")
    else
      object
    end
  end

end
