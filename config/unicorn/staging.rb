app_path = "/home/deploy/release/bnuoj-v4-rails/current"
shared_path = "/home/deploy/release/bnuoj-v4-rails/shared"
unicorn_pid = "/home/deploy/release/bnuoj-v4-rails/tmp/pids/unicorn.pid"

user 'deploy'
working_directory app_path
pid unicorn_pid
stderr_path "#{shared_path}/log/unicorn.log"
stdout_path "#{shared_path}/log/unicorn.log"

listen 3000
worker_processes 4
timeout 30
preload_app true

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/Gemfile"
end
