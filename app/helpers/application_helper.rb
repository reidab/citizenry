module ApplicationHelper
  def front_page?
    controller_name == 'site' && action_name == 'index'
  end

  def semantic_pluralize(count, singular, plural = nil)
    content_tag(:span, "#{count || 0} ", :class => 'count') +
      ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
  end

  def twitter_link(screen_name)
    url = "https://twitter.com/#{screen_name}"
    link_to "@#{screen_name}", url
  end

  # Return a URL for the given +string+.
  def normalize_url(string)
    return Addressable::URI.heuristic_parse(string).to_s
  end

  def provider_name(provider)
    OmniAuth::Utils.camelize(provider)
  end
end
