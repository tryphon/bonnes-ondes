require 'dragonfly/rails/images'

app = Dragonfly[:images]

images_storage_dir = Rails.root + 'storage/images'
FileUtils.mkdir_p images_storage_dir

app.datastore.configure do |d|
  d.root_path = images_storage_dir.to_s
  # d.server_root = '/filesystem/path/public'       # filesystem root for serving from - default to nil
end

app.configure do |c|
  c.url_format = '/images/:job.:format'
  c.url_host = "http://#{ResourceLink.admin_domain}" if Rails.env.production?
end
