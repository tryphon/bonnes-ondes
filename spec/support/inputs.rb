module InputExampleGroup
  extend ActiveSupport::Concern
  include RSpec::Rails::HelperExampleGroup
  include Capybara::RSpecMatchers

  def input_for(object, attribute_name, input_options = {}, form_options = {})
    form_options = { :url => '' }.merge(form_options)

    helper.simple_form_for object, form_options do |f|
      f.input attribute_name, input_options
    end.to_s
  end
end

RSpec.configure do |config|
  config.include InputExampleGroup, :type => :input, :example_group => {
    :file_path => config.escaped_path(%w[spec inputs])
  }
end