set :application, "bonnes-ondes"
set :scm, "git"
set :repository, "git://projects.tryphon.priv/bonnes-ondes"

set :deploy_to, "/var/www/bonnes-ondes"

set :keep_releases, 5
after "deploy:update", "deploy:cleanup"
set :use_sudo, false
default_run_options[:pty] = true

set :bundle_cmd, "/var/lib/gems/1.9.1/bin/bundle"
set :rake, "#{bundle_cmd} exec rake"

# server "sandbox", :app, :web, :db, :primary => true
server "bonnesondes.dbx1.tryphon.priv", :app, :web, :db, :primary => true

after "deploy:update_code", "deploy:symlink_shared", "deploy:bundle_link"

require "bundler/capistrano"
load "deploy/assets"

namespace :deploy do
  # Prevent errors when chmod isn't allowed by server
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(' ')} && (chmod g+w #{dirs.join(' ')} || true)"
  end

  desc "Symlinks shared configs and folders on each release"
  task :symlink_shared, :except => { :no_release => true }  do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/"

    storage_shared_dir = File.join(shared_path, "storage")
    storage_local_dir = File.join(release_path, "storage")
    run "ln -nfs #{storage_shared_dir} #{storage_local_dir}"

    # REMOVEME with direct access to /templates
    templates_local_dir = File.join(release_path, "templates")

    run "mv #{templates_local_dir} #{templates_local_dir}.orig"
    sudo "rsync -a #{templates_local_dir}.orig/ #{storage_local_dir}/templates/", :as => "www-data"

    run "ln -nfs #{storage_local_dir}/templates #{templates_local_dir}"

    cache_local_dir = File.join(release_path, "tmp", "cache")
    run "ln -nfs #{storage_local_dir}/cache #{cache_local_dir}"
  end

  task :bundle_link do
    run "ln -fs #{bundle_cmd} #{release_path}/script/bundle"
  end
end

desc "Create data directories"
task :after_setup, :roles => [:app, :web] do
  templates_shared_dir = File.join(shared_path, "templates")
  run "umask 02 && mkdir -p #{templates_shared_dir}"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
