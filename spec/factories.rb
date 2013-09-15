puts "Loading factories ..."

Factory.define :user do |u|
  u.sequence(:login) { |n| "username-#{n}" }
  u.sequence(:email) { |n| "dummy#{n}@tryphon.org" }

  password = "password"
  u.password password
  u.password_confirmation password

  u.activated_at Time.now
end

Factory.define :show do |f|
  f.sequence(:slug) { |n| "slug-#{n}" }
  f.name "name"
  f.description "description"
  f.users { |users| [users.association(:user)] }
  f.association :template

  f.after_build do |show|
    2.times { show.episodes << Factory.build(:episode, :show => show) }
  end
end

Factory.define :radio do |f|
  f.sequence(:slug) { |n| "slug-#{n}" }
end

Factory.define :episode do |f|
  f.association :show

  f.sequence(:slug) { |n| "episode-#{n}" }
  f.sequence(:order) { |n| n }
  f.title "title"
  f.description "description"
  f.after_build do |episode|
    3.times { episode.contents << Factory.build(:content, :episode => episode) }
  end
end

Factory.define :content, :class => TestContent do |f|
  f.association :episode

  f.sequence(:slug) { |n| "content-#{n}" }
  f.name "name"
  f.principal true
end

class AudiobankProjectMock

  def exists?(id)
    true
  end

  def document(id)
    nil
  end

end

Factory.define :audiobank_content do |f|
  f.sequence(:slug) { |n| "content-#{n}" }
  f.name "name"
  f.principal true
  f.audiobank_id 123
  f.association :episode

  f.after_build { |content|
    content.audiobank_project = AudiobankProjectMock.new
  }
end

Factory.define :post do |u|
  u.sequence(:slug) { |n| "slug-#{n}" }
  u.title "name"
  u.description "description"
  u.association :show
end

Factory.define :page do |u|
  u.sequence(:slug) { |n| "slug-#{n}" }
  u.title "name"
  u.content "content"
  u.association :show
end

Factory.define :image do |u|
  u.title "name"
  u.content TestUploadedFile.new("#{File.dirname(__FILE__)}/fixtures/image.jpg", "image/jpeg")
  u.association :show
end

Factory.define :template do |f|
  f.name "Test"
  f.sequence(:slug) { |n| "test-#{n}" }
  f.scm_url "dummy"
end

Factory.define :audiobank_project do |f|
  f.sequence(:token) { |n| "user:password" }
  f.association :show
end

Factory.define :host do |f|
  f.sequence(:name) { |n| "host#{n}.example.com" }
end
