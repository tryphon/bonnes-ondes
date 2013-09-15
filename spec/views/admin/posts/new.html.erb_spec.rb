require 'spec_helper'

describe "/admin/posts/new" do

  let!(:post) { assign :post, show.posts.build }
  let!(:show) { assign :show, Factory(:show) }

  it "should render new form" do
    render

    rendered.should have_selector("form[method=post]", :action => admin_show_posts_path(show))

    rendered.should have_selector("form input#post_title", :name => "post[title]")
    rendered.should have_selector("form input#post_slug", :name => "post[slug]")
    rendered.should have_selector("form textarea#post_description", :name => "post[description]")
  end
end
