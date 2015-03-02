APPDIR = "/vagrant" # Application directory
USER = "vagrant"      # User that owns files
TEMP_DIR = "/usr/local/src"

# Change directory to /vagrant after doing a `vagrant ssh`.
execute "update-profile-chdir" do
  profile = "~vagrant/.profile"
  command %{printf "\nif shopt -q login_shell; then cd #{APPDIR}; fi" >> #{profile}}
  not_if "grep -q 'cd #{APPDIR}' #{profile}"
end

# Update package list, but only if stale
execute "update-apt" do
  timestamp = "/root/.apt-get-updated"
  command "apt-get update && touch #{timestamp}"
  only_if do
    ! File.exist?(timestamp) || (File.stat(timestamp).mtime + 60*60) < Time.now
  end
end

# Install a modern Ruby version
execute "Create Temp Dir" do
  command "mkdir -p #{TEMP_DIR}"
end

execute "Get ruby source"do
  cwd TEMP_DIR
  command "wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz"
end

execute "Extract Ruby Source" do
  cwd TEMP_DIR
  command "tar -xvzf ruby-2.1.2.tar.gz && rm ruby-2.1.2.tar.gz"
end

execute "Configure ruby for build" do
  cwd "#{TEMP_DIR}/ruby-2.1.2"
  command "./configure --prefix=/opt/vagrant_ruby"
end

execute "Make and Install Ruby" do
  cwd "#{TEMP_DIR}/ruby-2.1.2"
  command "make && sudo make install"
end

# Remove obsolete file
file "/etc/profile.d/rubygems1.8.sh" do
  action :delete
end

# Add gems to PATH, use "zz-" prefix to ensure this runs after box's "vagrantruby.sh".
file "/etc/profile.d/zz-rubygems1.8.sh" do
  content "export PATH=`gem env path`:$PATH"
end

# Remove conflicting packages
for name in %w[irb ruby-dev]
  package name do
    action :remove
  end
end

# Install packages
for name in %w[nfs-common git-core screen tmux elinks build-essential libcurl4-openssl-dev libsqlite3-dev mysql-server libmysqlclient-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev sphinxsearch imagemagick]
  package name
end

# Install gems
gem_package "bundler"
gem_package "rake"

# Fix permissions on homedir
execute "chown -R #{USER}:#{USER} ~#{USER}"

# Run the contents of the "vagrant/cookbooks/vagrant/recipes/local.rb" file if present. This optional file can contain additional provisioning logic that shouldn't be part of the global setup. For example, if you're using the "Gemfile.local" to install special gems, you'd use this "local.rb" to install their dependencies.
local_recipe = File.join(File.dirname(__FILE__), "local.rb")
if File.exist?(local_recipe)
  eval File.read(local_recipe)
end

# Copy in sample YML files, if needed:
for name in %w[settings database]
  source = "#{APPDIR}/config/#{name}-sample.yml"
  target = "#{APPDIR}/config/#{name}.yml"

  execute "cp -a #{source} #{target}" do
    not_if "test -e #{target}"
  end
end

# Fix permissions on homedir
execute "chown -R #{USER}:#{USER} ~#{USER}"

# Install bundle
execute "install-bundle" do
  cwd APPDIR
  command "su vagrant -l -c 'bundle check || bundle --local || bundle'"
end

# Setup database
execute "setup-db" do
  cwd APPDIR
  command "su vagrant -l -c 'bundle exec rake db:create:all db:migrate db:test:prepare'"
end
