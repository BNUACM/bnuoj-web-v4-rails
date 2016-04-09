# config valid only for Capistrano 3.1
lock '>=3.1.0'

set :application, 'bnuoj_v4'
set :repo_url, 'https://github.com/BNUACM/bnuoj-web-v4-rails.git'

# Default branch is :master
set :branch, 'develop'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/release/bnuoj-v4-rails'

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

set :linked_dirs, %w{bin log tmp}

set :rvm1_ruby_version, "2.3.0"       # use the same ruby as used locally for deployment

before 'deploy', 'rvm1:install:rvm'  # install/update RVM
before 'deploy', 'rvm1:install:ruby' # install Ruby and create gemset (both if missing)

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

  task :copy_config_file do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cp -f ~/bnuoj-configs/v4/database.yml #{release_path}/config/database.yml"
      execute "cp -f ~/bnuoj-configs/v4/oj_config.yml #{release_path}/config/oj_config.yml"
    end
  end

  after :updating, :copy_config_file

  desc 'Restart application'
  task :restart do
    invoke 'puma:restart'
  end

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
