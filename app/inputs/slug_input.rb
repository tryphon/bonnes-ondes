class SlugInput < SimpleForm::Inputs::StringInput

  def input_html_options
  	super.merge "data-slug-url" => slug_url, "data-slug-source" => default_slug_source
  end

  def slug_url
  	"#{builder_url}/slug.json"
  end

  def default_slug_source
  	%w{name title}.find do |attribute|
  		object.respond_to? attribute
  	end
  end

  def builder_url
  	@builder.options[:url]
  end  	

end
