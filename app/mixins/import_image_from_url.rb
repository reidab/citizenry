module ImportImageFromURL
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Setup this model so it can import images from URLs.
    def import_image_from_url_setup
      unless self.respond_to?(:import_image_from_url_settings)
        # Create hash to store this model's importer settings
        cattr_accessor :import_image_from_url_settings
        self.import_image_from_url_settings = {}

        # Add validation to import images from URLs
        validate :import_images
      end
    end

    # Tell this model to import an image from a URL and store it as the attribute +field+.
    #
    # @param [Symbol] field the attribute name to setup as the PaperClip attachment handle, e.g. +:photo+.
    # @param [Hash] opts the options customizing the behavior of the importer for this field.
    # @options opts [Hash{Symbol=>String}] :thumbnail_styles { :medium => '220x220#', :thumb => '48x48#' } PaperClip thumbnail styles for this field.
    # @options opts [Boolean] :gravatar (false) Display an image from Gravatar if an image wasn't otherwise specified?
    # @options opts [Hash{Symbol=>Fixnum}] :gravatar_sizes ({ :medium => 220, :thumb => 48 }) Gravatar image sizes in pixels for this field.
    # @options opts [String] :url ('/system/:attachment/:id/:style/:safe_filename') The PaperClip path used for storing and serving the image.
    # @options opts [Fixnum] :maximum_size (1000.kilobytes) The maximum size of the image in bytes.
    # @options opts [Fixnum] :timeout_seconds (10) The number of seconds to try to download the image before timing-out.
    def import_image_from_url_as(field, opts={})
      self.import_image_from_url_setup

      field = field.to_sym

      # Save field's settings based user's preferences and defaults
      leaf = self.import_image_from_url_settings[field] = {
        :thumbnail_styles => opts[:thumbnail_styles] || { :medium => '220x220#', :thumb => '48x48#' },
        :gravatar => opts[:gravatar].nil? ? false : opts[:gravatar],
        :gravatar_sizes => opts[:gravatar_sizes] || { :medium => 220, :thumb => 48 },
        :url => opts[:url] || '/system/:attachment/:id/:style/:safe_filename',
        :maximum_size => opts[:maximum_size] || 1000.kilobytes,
        :timeout_seconds => opts[:timeout_seconds] || 10,
      }

      # Activate PaperClip attachment on field
      self.has_attached_file(field, :styles => leaf[:thumbnail_styles])

      # Validate size of attachment
      self.validates_attachment_size(field, :less_than => leaf[:maximum_size])

      # Setup attribute containing the URL to import from
      field_import_url = "#{field}_import_url"
      self.send(:attr_accessor, field_import_url)

      # Define method for returning the attachment's URL
      self.class_eval <<-HERE
        def #{field}_url(size=:medium)
          if self.#{field}.file?
            return self.#{field}.url(size)
          end

          if self.class.import_image_from_url_settings[:#{field}][:gravatar]
            return "http://www.gravatar.com/avatar/\#{Digest::MD5.hexdigest(self.id.to_s)}?d=retro&f=y&s=\#{self.class.import_image_from_url_settings[:#{field}][:gravatar_sizes][size]}"
          end

          return nil
        end
      HERE
    end
  end

  # Import the images -- which will be done automatically during validation.
  #
  # @return [Boolean] Were all images imported successfully?
  def import_images
    settings = self.class.import_image_from_url_settings
    if settings.any?
      for field in settings.keys
        leaf = settings[field]
        field_import_url = "#{field}_import_url"

        if self.send(field_import_url).present?
          # Normalize
          url = self.send(field_import_url)
          url = "http://#{url}" unless url.include?("http")

          # Validate URL
          begin
            uri = URI.parse(url)
          rescue URI::InvalidURIError
            self.errors.add(field_import_url, "was invalid")
            return false
          end

          # Download
          io = nil
          begin
            Timeout::timeout(leaf[:timeout_seconds]) do
              io = uri.open
            end
          rescue SocketError => e
            self.errors.add(field_import_url, "could not be retrieved: #{e}")
            return false
          rescue OpenURI::HTTPError => e
            self.errors.add(field_import_url, "could not be retrieved: #{e}")
            return false
          rescue Timeout::Error => e
            self.errors.add(field_import_url, "could not be retrieved because it timed-out after #{leaf[:timeout_seconds]} seconds")
            return false
          end

          # Validate status
          unless io.status.first.to_i == 200
            self.errors.add(field_import_url, "could not be retrieved because of HTTP error: #{io.status.first} -- #{io.status.last}")
            return false
          end

          # Validate size
          if io.size == 0
            self.errors.add(field_import_url, "could not be imported, file size is 0 bytes")
            return false
          elsif io.size > leaf[:maximum_size]
            self.errors.add(field_import_url, "could not be imported, size must be smaller than #{leaf[:maximum_size]} bytes, but was #{io.size} bytes")
            return false
          end

          # Provide a way to get the filename from the 'open-uri' result
          def io.original_filename
            base_uri.path.split('/').last
          end

          # Assert thumbnail creation
          begin
            self.send("#{field}=", io)
          rescue Exception => e
            self.errors.add(field_import_url, "could not be imported, file doesn't seem to be an image -- thumbnail generation failed with: #{e}")
            return false
          end
        end
      end
    end

    return true
  end
end
