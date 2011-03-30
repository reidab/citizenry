module Moonshine
  module AstrailsSafe

    # Define options for this plugin via the <tt>configure</tt> method
    # in your application manifest:
    #
    #   configure(:astrails_safe => {:foo => true})
    #
    # Then include the plugin and call the recipe(s) you need:
    #
    #  plugin :astrails_safe
    #  recipe :astrails_safe
  
    # setting defaults to make template a little cleaner
    def astrails_safe(options = {})
    
      options[:local]   ||= {}
      options[:mysql]   ||= {}
      options[:mongodb] ||= {}
    
      # define the recipe
      # options specified with the configure method will be 
      # automatically available here in the options hash.
      #    options[:foo]   # => true
      gem 'astrails-safe'
      package 'gpg'

      file '/etc/astrails', :ensure => :directory, :mode => '644'
      file '/etc/astrails/safe.conf',
        :mode => '644',
        :require => file('/etc/astrails'),
        :content => template(File.join(File.dirname(__FILE__), 'astrails_safe', 'templates', 'safe.conf'), binding)

     # unless cron is  false, the default backup is every night at midnight
     unless options[:cron] == false
       options[:cron] ||= {}
       cron 'astrails-safe',
        :command    => options[:cron][:command] || 'astrails-safe /etc/astrails/safe.conf',
        :minute     => options[:cron][:minute] || 0,
        :hour       => options[:cron][:hour] || 0,
        :monthday   => options[:cron][:monthday] || '*',
        :month      => options[:cron][:month] || '*',
        :weekday    => options[:cron][:weekday] || '*',
        :user       => options[:cron][:user] || configuration[:user]
     end
    
    end
  
  end
end