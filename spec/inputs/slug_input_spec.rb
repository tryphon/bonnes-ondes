require 'spec_helper'

describe "SlugInput" do

	def slug_input(form_options = {})
		input_for(:foo, :slug, { :as => :slug }, form_options)
	end	

  it 'create a text input' do
    slug_input.should have_selector("input", :type => "text", :name => "foo[slug]")
  end

	context "when builder url is '/compte/shows/slug-1/posts'" do

	  it "should set data-slug-url at '/compte/shows/slug-1/posts/slug'" do
	    slug_input(:url => '/compte/shows/slug-1/posts').should have_selector("input[data-slug-url='/compte/shows/slug-1/posts/slug']")
	  end

	end

end