require 'dragonfly/rails/images'

app = Dragonfly[:images]

images_storage_dir = Rails.root + 'storage/images'
FileUtils.mkdir_p images_storage_dir

app.datastore.configure do |d|
  d.root_path = images_storage_dir
  # d.server_root = '/filesystem/path/public'       # filesystem root for serving from - default to nil
end
