set :application, "Tempo"
set :repository,  "git@github.com:bryansray/tempo.git"
set :domain, "web-server"

default_run_options[:pty] = true

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :scm, :git
set :deploy_via, :remote_cache

ssh_options[:paranoid] = false

set :user, "mongrel"
set :runner, "mongrel"
set :use_sudo, false


role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Move over configuration files after deploying the code
task :update_config, :roles => [:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
end

after 'deploy:update_code', :update_config