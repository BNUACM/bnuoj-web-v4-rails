# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'bnuoj_v4'
set :repo_url, 'git@github.com:BNUACM/bnuoj-web-v4-rails.git'

# Default branch is :master
set :branch, 'develop'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/bnuoj-v4-rails'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  task :install_bower do
    on roles(:app) do
      within release_path do
        execute :rake, 'bower:install'
        execute :rake, 'bower:resolve'
      end
    end
  end

  before 'assets:precompile', :install_bower

  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec unicorn_rails -D -E #{env.fetch(:stage)} -c config/unicorn.conf"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')

      execute "kill -USR2 `cat #{deploy_to}/tmp/pids/unicorn.pid`"
      sleep 5
      execute "kill -WINCH `cat #{deploy_to}/tmp/pids/unicorn.pid.oldbin`"
      sleep 5
      execute "kill -QUIT `cat #{deploy_to}/tmp/pids/unicorn.pid.oldbin`"
    end
  end
  
  after :publishing, :cleanup 
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do

      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
