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
    base.send(:extend, ::CustomizableSlug::ClassMethods)
  end

  module ClassMethods
    # Add logic for managing a customizable custom slug on the +attribute+, e.g. :name.
    def customizable_slug_from(attribute)
      # The models' attribute which contains the source value to use for generating a friendly id, e.g. :name.
      cattr_accessor :friendly_id_source_attribute
      self.friendly_id_source_attribute = attribute

      # Accessor used by internals of "friendly_id" plugin.
      attr_accessor :generate_new_slug

      extend FriendlyId
      friendly_id :custom_slug_or_source, :use => :slugged, :slug_generator_class => ::CustomizableSlug::CustomizableSlugGenerator
    end
  end

  # Return the user-specified custom slug or the friendly id for this record.
  def custom_slug
    @custom_slug.presence || self.friendly_id
  end

  # Set the custom slug to +value+.
  def custom_slug=(value)
    @custom_slug = value
  end

  # Return the custom slug or the value of the attribute that contains the source value.
  def custom_slug_or_source
    @custom_slug.presence || "#{self.send(self.class.friendly_id_source_attribute)}"
  end

  # Method used by internals of "friendly_id" plugin.
  def should_generate_new_friendly_id?
    if @custom_slug.present? || self.generate_new_slug == "1"
      super
    else
      ! self.slug
    end
  end
end
