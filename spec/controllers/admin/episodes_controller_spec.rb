require 'spec_helper'

describe Admin::EpisodesController do
  include AuthenticatedTestHelper

  before { login_as show.users.first }

  let(:show) { Factory(:show) }

  describe "GET /index" do

    it "should find Show episodes" do
      get :index, :show_id => show.slug
      assigns(:episodes).should =~ show.episodes
    end

    context "when filter is without_content" do

      it "should find episodes without content" do
        episode_without_content = show.episodes.first.tap { |e| e.contents.clear }

        get :index, :show_id => show.slug, :filter => 'without_content'
        assigns(:episodes).should =~ [ episode_without_content ]
      end

    end

    context "when a tag is specified" do

      let(:tag) { Tag.new(:name => 'dummy') }

      it "should find episodes with this tag" do
        episode_with_tag = show.episodes.first.tap { |e| e.tags << tag }

        get :index, :show_id => show.slug, :tag => tag.id
        assigns(:episodes).should =~ [ episode_with_tag ]
      end

    end

  end


end
