# Provides facility to set default options for to_json at the class level.
module DefaultSerializationOptions
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def default_json_options(options)
      cattr_accessor :default_json_options
      self.default_json_options = options
      self.send(:include, DefaultSerializationOptions::InstanceMethods)
      self.send(:alias_method_chain, :as_json, :defaults)
    end

    def default_xml_options(options)
      cattr_accessor :default_xml_options
      self.default_xml_options = options
      self.send(:include, DefaultSerializationOptions::InstanceMethods)
      self.send(:alias_method_chain, :to_xml, :defaults)
    end
  end

  module InstanceMethods
    def as_json_with_defaults(options = {})
      as_json_without_defaults(options.reverse_merge(self.class.default_json_options))
    end

    def to_xml_with_defaults(options = {})
      to_xml_without_defaults(options.reverse_merge(self.class.default_xml_options))
    end
  end
end

ActiveRecord::Base.send(:include, DefaultSerializationOptions)
