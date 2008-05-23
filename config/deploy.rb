default_run_options[:pty] = true

set :application, "Tempo"
set :domain, "192.168.0.194"
set :user, "bryan"

set :runner, "www-data"

set :scm, :git
set :repository,  "git@github.com:bryansray/tempo.git"

set :ssh_options, { :forward_agent => true }
set :branch, "master"

set :deploy_to, "/var/www/tempo"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Move over configuration files after deploying the code
task :update_config, :roles => [:app] do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

namespace :mod_rails do
  desc <<-DESC
  Restart the application altering tmp/restart.txt for mod_rails.
  DESC
  task :restart, :roles => :app do
    run "touch  #{release_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  %w(start restart).each { |name| task name, :roles => :app do mod_rails.restart end }
end


after 'deploy:update_code', :update_config