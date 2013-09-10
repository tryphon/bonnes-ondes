require 'spec_helper'

describe "admin/posts/index" do
  include PostsHelper

  before(:each) do
    assigns[:show] = @show = Factory(:show)
    assigns[:posts] = @posts = Array.new(2) do
      Factory(:post,
              :show => @show,
              :title => "value for title",
              :slug => "value for slug",
              :description => "value for description")
    end
  end

  it "should render list of posts" do
    render
    @posts.each do |post|
      rendered.should have_selector("a", :text => post.title)
    end
  end

  it "should render link to show each post" do
    render
    @posts.each do |post|
      rendered.should have_selector("a", :href => admin_show_post_path(@show, post))
    end
  end

end
