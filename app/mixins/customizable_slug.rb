# = CustomizableSlug
#
# This mixin provides a easy-to-use wrapper for setting up customizable slugs using the <tt>friendly_id</tt> plugin.
#
# @example To add a customizable slug whose default value is based on the :name field, add this to your ActiveRecord model:
#   class MyModel
#     customizable_slug_from :name
#   end
#
# @example To use the customizable field:
#   m = MyModel.new(:name => "foo")
#
#   m.save
#   m.slug # => "foo"
#
#   m.custom_slug = "bar"
#   m.save
#   m.slug # => "bar"
module CustomizableSlug

  require 'friendly_id/slug_generator'
  class CustomizableSlugGenerator < FriendlyId::SlugGenerator
    def generate
      if conflict?
        sluggable.errors.add(:custom_slug, "is not unique")
      end
      normalized
    end
  end

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    def customizable_slug_from(attribute)
      # The models' attribute which contains the source value to use for generating a friendly id, e.g. :name.
      cattr_accessor :friendly_id_source_attribute
      self.friendly_id_source_attribute = attribute

      # The user-specified custom slug that will override the friendly id.
      attr_accessor :custom_slug

      # Accessor used by internals of "friendly_id" plugin.
      attr_accessor :generate_new_slug

      extend FriendlyId
      friendly_id :custom_slug_or_source, :use => :slugged, :slug_generator_class => CustomizableSlug::CustomizableSlugGenerator
    end
  end

  def custom_slug_or_friendly_id
    self.custom_slug.present? ? self.custom_slug : self.friendly_id
  end

  def custom_slug_or_friendly_id=(value)
    self.custom_slug = value
  end

  def custom_slug_or_source
    self.custom_slug.present? ? self.custom_slug : "#{self.send(self.class.friendly_id_source_attribute)}"
  end

  def should_generate_new_friendly_id?
    if self.custom_slug.present? || self.generate_new_slug == "1"
      super
    else
      ! self.slug
    end
  end
end
