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

  def render_flash
    unless flash.blank?
      content_tag("div", :id => "flash", :class => "flash") do
        flash.keys.sort{|a,b| a.to_s <=> b.to_s }.map do |key|
          render_message(key, flash[key])
        end.join("\n").html_safe
      end
    end
  end

  def render_message(type, content, label = true)
    classes = ['message', type, (label ? 'with_label' : nil)]
    title = flash_type_title(type)
    content_tag("div", :class => classes.compact.join(' ')) do
      (label ? content_tag(:span, title, :class => 'message_type') : '') << content_tag(:div, content, :class => 'message_content')
    end
  end

  def flash_type_title(type)
    flowery_vocabulary = {
      :error   => [ 'Egads', 'Balderdash', 'Fiddlesticks', 'Holy Toledo', 'Tarnation', 'Damnation', 'Fooey',
                    'Boo', 'Aw shucks', 'Uh oh', 'Great Scott', "Blisterin' barnacles" ],
      :success => [ 'Yippee', 'Hooray', 'Awesome', 'Yeehaw', 'Hoorah', 'Huzzah', 'Yeah', 'Yay' ],
      :notice  => [ 'Heads up', 'Avast', 'Notice' ],
      :warning => [ 'Beware', 'Warning', 'Watch out' ]
    }

    if flowery_vocabulary[type]
      return "#{flowery_vocabulary[type].choice}!"
    else
      return type.to_s.titleize
    end
  end
end
