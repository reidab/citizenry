# From: https://gist.github.com/1401792

# web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb

# config/unicorn.rb

# See comment by @paulelliott
worker_processes 3
timeout 30
preload_app true

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Resque')
  end
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    if Rails.env.development? || Rails.env.test?
      resque_config = YAML.load_file("#{Rails.root}/config/resque.yml")
      Resque.redis = resque_config[Rails.env]
      Rails.logger.info('Connected to Redis (development)')
    else
      Resque.redis = ENV['REDISTOGO_URL']
      Rails.logger.info('Connected to Resque (production)')
    end
  end
end