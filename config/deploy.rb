server 'epdx', :app, :web, :db, :primary => true

before 'deploy:symlink', 'epdx:update_calagator_count'
namespace :epdx do
  task :update_calagator_count do
    run "cd #{release_path} && rake RAILS_ENV=#{rails_env} calagator:update_count"
  end
end

namespace :db do
  namespace :remote do
    desc "Dump database on remote server"
    task :dump, :roles => :db, :only => {:primary => true} do
      run "(cd #{current_path} && rake RAILS_ENV=production db:raw:dump FILE=#{shared_path}/db/database.sql)"
    end
  end

  namespace :local do
    desc "Restore downloaded database on local server"
    task :restore, :roles => :db, :only => {:primary => true} do
      system "rake db:raw:dump FILE=database~old.sql && rake db:raw:restore FILE=database.sql"
    end
  end

  desc "Download database from remote server"
  task :download, :roles => :db, :only => {:primary => true} do
    system "rsync -uvax #{user}@#{domain}:#{shared_path}/db/database.sql ."
  end

  desc "Use: dump and download remote database and restore it locally"
  task :use, :roles => :db, :only => {:primary => true} do
    db.remote.dump
    db.download
    db.local.restore
  end
end
