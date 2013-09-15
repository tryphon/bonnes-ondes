require 'spec_helper'

describe "/admin/posts/edit" do

  let!(:post) { assign :post, Factory(:post) }
  let!(:show) { assign :show, post.show }

  it "should render edit form" do
    render

    rendered.should have_selector("form", :action => admin_show_post_path(show, post))

    rendered.should have_selector("form input#post_title", :name => "post[title]")
    rendered.should_not have_selector("form input#post_slug", :name => "post[slug]")
    rendered.should have_selector("form textarea#post_description", :name => "post[description]")
  end
end
