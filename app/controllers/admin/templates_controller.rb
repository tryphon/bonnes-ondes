class Admin::TemplatesController < AdminController
  defaults :collection_name => 'user_templates', :instance_name => 'user_template'

  def create
    create!
    @user_template.users << current_user
  end

  def edit
    edit!
    @user_template.touch
  end 

  protected

  def method_for_association_chain
    :templates
  end
end
