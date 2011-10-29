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

  # Override behavior of gem.
  require 'friendly_id/slug_generator'
  class CustomizableSlugGenerator < FriendlyId::SlugGenerator
    # When generating the slug, if there's a conflict, stop immediately and mark the record as an error so they can pick something else.
    #
    # The gem's original behavior is to always generate a unique slug, even if this means adding a number to the end of it. This is bad design because if the user wants to be "foo", but that's taken, they'll end up as "foo-2", rather than being told to pick another slug.
    def generate
      if conflict?
        sluggable.errors.add(:custom_slug, "is not unique")
      end
      return normalized
    end

    # Check history for conflicts, if using history.
    #
    # The gem's original behavior doesn't check history, so if you try to create a conflicting record, the #save will fail with a raw SQL uniqueness constraint error.
    def conflicts
      # If any regular conflicts are found, return them immediately.
      scope = super
      return scope if scope.count > 0

      # If no regular conflicts are found, search the history.
      if friendly_id_config.model_class.included_modules.include?(FriendlyId::History)
        history = FriendlyId::Slug.where(:slug => normalized, :sluggable_type => self.sluggable.class.to_s)
        unless self.sluggable.new_record?
          # If record exists, exclude it from the history check.
          history = history.where('sluggable_id <> ?', self.sluggable.id)
        end

        return history if history.count > 0
      end

      # No conflicts of any sort found.
      return []
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

      # Activate "friendly_id" plugin.
      extend FriendlyId
      friendly_id :custom_slug_or_source, :use => :history, :slug_generator_class => ::CustomizableSlug::CustomizableSlugGenerator

      # Add validation for "custom_slug" field.
      validate :validate_custom_slug
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
    return false
    # if @custom_slug.present? || self.generate_new_slug == "1"
    if @custom_slug != self.sluggable.slug || self.generate_new_slug == "1"
      super
    else
      ! self.slug
    end
  end

  def validate_custom_slug
    # Ensure that the slug starts with a letter or Rails will try to match it as a numeric ID. :(
    #
    # TODO Figure out what to do about slugs that really start with a digit, e.g. "37signals".
    if @custom_slug.present? && @custom_slug !~ /\D/
      self.errors.add(:custom_slug, "must contain a non-digit character")
    end
  end
end
