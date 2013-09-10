class Admin::ShowsController < AdminController

  def edit
    @selectable_templates = selectable_templates
    edit!
  end

  def new
    @selectable_templates = selectable_templates
    new!
  end

  def create
    create!

    # has_and_belongs_to_many#build doesn't add
    # new instanct in target collection
    current_user.shows << @show if @show.persisted?
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to admin_path }
    end
  end

  def slug
    @slug = Slug.slugify(params[:name])
  end

  protected

  def selectable_templates
    if current_user.templates.empty?
      []
    else
      ([ Show.default_template, resource.try(:template) ].compact + current_user.templates).uniq
    end
  end

end
