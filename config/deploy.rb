server 'epdx', :app, :web, :db, :primary => true

before 'deploy:symlink', 'epdx:update_calagator_count'
namespace :epdx do
  task :update_calagator_count do
    run "cd #{release_path} && rake RAILS_ENV=#{rails_env} calagator:update_count"
  end
end
