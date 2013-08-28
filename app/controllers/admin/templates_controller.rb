class Admin::TemplatesController < AdminController
  defaults :collection_name => 'user_templates', :instance_name => 'user_template'

  def create
    create!
    @user_template.users << current_user
  end

  protected

  def method_for_association_chain
    :templates
  end
end
