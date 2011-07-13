namespace :ci do
  desc "Setup configuration files for running tests under Travis CI"
  task :setup do
    cp ::Rails.root.join('config','database-sample.yml'), ::Rails.root.join('config', 'database.yml') unless File.exist?(::Rails.root.join('config', 'database.yml'))
    cp ::Rails.root.join('config','settings-sample.yml'), ::Rails.root.join('config', 'settings.yml') unless File.exist?(::Rails.root.join('config', 'settings.yml'))
  end
end
