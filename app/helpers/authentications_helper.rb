module AuthenticationsHelper
  def provider_icon(provider, size=32)
    path = File.join('authbuttons',"#{provider}_#{size}.png")
    provider_name = OmniAuth::Utils.camelize(provider)

    if File.exists?(Rails.root.join('public', 'images', path))
      image_tag(path, :alt => provider_name)
    else
      provider_name
    end
  end
end
