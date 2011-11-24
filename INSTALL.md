Citizenry installation guide
============================

Installing Citizenry isn't hard, just follow this guide. If you encounter issues, please report them and offer suggestions that improve this installation guide.

Prepare
-------

You will need to:

  1. [Install git](http://git-scm.com/), a distributed version control system. Read the [Github Git Guides](http://github.com/guides/home) to learn how to use *git*.
  2. [Install Ruby](http://www.ruby-lang.org/), a programming language. You can use MRI Ruby 1.8.7, or [Phusion REE (Ruby Enterprise Edition)](http://rubyenterpriseedition.com/). Your operating system may already have it installed or offer it as a pre-built package.
  3. [Install RubyGems](http://rubyforge.org/projects/rubygems/) 1.3.x or newer, a tool for managing software packages for Ruby.
  4. [Install ImageMagick](http://www.imagemagick.org/) a tool for manipulating images
  5. Checkout the source code. Run `git clone git://github.com/reidab/citizenry.git`, which will create a `citizenry` directory with the source code. Go into this directory and run the remaining commands from there.

Development
-----------

You have a choice for how to setup the development environment:

* Vagrant virtual machine: This will make setup very easy because almost everything will be done for you.
* Local machine: This will make setup more difficult, but may be advantageous for advanced users.

### Development using Vagrant virtual machine

[Vagrant](http://vagrantup.com/) is a tool used by this project to provide you with a complete, working copy of the development environment. Using Vagrant will make it easier and faster to begin working on this project than if you were to try to set everything up yourself. Vagrant works by creating a virtual machine -- an isolated operating system that runs within your normal operating system. This virtual machine has been specially prepared to include everything needed to develop and run the application.

To learn how to use Vagrant with this project, please read the `VAGRANT.md` file. You will not need to

### Development using local machine

You will need to install more software to do development on your local machine:

  1. [Install MySQL](http://www.mysql.org/), a database engine. Your operating system may already have it installed or offer it as a pre-built package.

  1. If you're using RVM and Ruby 1.9, you *must* install some libraries manually because Bundler can't:

    gem install linecache19 -- --with-ruby-include=$rvm_path/src/${RUBY_VERSION?}
    gem install ruby-debug19 -- --with-ruby-include=$rvm_path/src/${RUBY_VERSION?}

  1. [Install Bundler](http://gembundler.com/), a Ruby dependency management tool. You should run `gem install bundler` as root or an administrator after installing Ruby and RubyGems.

  1. Install Bundler-managed gems, the actual libraries that this application uses, like Ruby on Rails. You should run `bundle`, which may take a long time to complete. This may fail because your computer is missing development libraries. Please read the error messages you get because they'll tell you what you're missing, and use a web search engine with the error message if you need help figuring out how to install that library. For example, on a modern Ubuntu distribution, you will need to install these packages:

        sudo apt-get install -y build-essential ruby ruby-dev irb libcurl4-openssl-dev libsqlite3-dev mysql-server libmysqlclient-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev sphinxsearch

  1. Copy the sample database settings into place:

        cp config/database-sample.yml config/database.yml

  1. Configure the database settings in the `config/database.yml` file as needed, see the instructions in the `config/database-sample.yml` file for details.

  1. Copy the sample application settings into place:

        cp config/settings-sample.yml config/settings.yml

  1. Configure the application settings in the `config/settings.yml` file as needed, see the instructions in the `config/settings-sample.yml` file for details.

  1. Initialize your database, run `bundle exec rake db:create:all db:migrate db:test:prepare`

Running the Citizenry application:

  * Start the *Ruby on Rails* web application by running `rails server` (UNIX) or `ruby script/rails server` (Windows).
  * Open a web browser to <http://localhost:3000/> to use the `development` server.
  * To stop the server, go to the terminal that you ran `rails server` in and press `CTRL-C`.
