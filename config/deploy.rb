# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'epdx'
set :repo_url, 'git@github.com:reidab/citizenry.git'

# Default branch is :master
set :branch, 'new_epdx_deploy'
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/epdx'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/settings.yml config/thinking_sphinx.yml config/production.sphinx.conf}
#set :linked_files, %w{config/database.yml config/settings.yml config/sphinx.conf config/sphinx.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :rails_env, :production
set :default_env, {
  path: "#{shared_path}/ruby/bin:#{shared_path}/bin:$PATH:/sbin",
  rails_env: fetch(:rails_env)
}

set :bundle_flags, '--quiet'

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  [:start, :stop, :reload].each do |t|
    desc '#{t} the application'
    task t do
      on roles(:app), in: :sequence, wait: 5 do
        execute :sudo, t, fetch(:application)
      end
    end
  end

  desc "restart the application (or start it, if it's not running)"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo restart #{fetch(:application)} || sudo start #{fetch(:application)}"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
       within release_path do
         execute :rake, 'tmp:cache:clear'
       end
    end
  end
end
