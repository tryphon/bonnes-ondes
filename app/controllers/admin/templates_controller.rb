class Admin::TemplatesController < AdminController
  defaults :collection_name => 'user_templates', :instance_name => 'user_template'

  def create
    create!
  end

  def edit
    edit!
    @user_template.touch
  end

  def show
    @ftp_account = current_user.ftp_accounts.where(:template_id => resource).first
    show!
  end

  protected

  def method_for_association_chain
    :templates
  end

  def create_resource(user_template)
    user_template.users << current_user
    super
  end

end
