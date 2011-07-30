module ApplicationHelper
  def semantic_pluralize(count, singular, plural = nil)
    content_tag(:span, "#{count || 0} ", :class => 'count') +
      ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
  end

  def twitter_link(screen_name)
    url = "https://twitter.com/#{screen_name}"
    link_to "@#{screen_name}", url
  end

  # Generates a link to sort the collection by the given column
  #
  # Options:
  #   - :label => The text of the link, defaults to the humanized version of the column name
  #   - :default_order => Direction to use when first sorting by this column, either :asc or :desc
  #   - :is_default =>  Specifies that the given column has been set as the default on the model, 
  #                     in order to properly assign the 'current' class on initial page load with
  #                     no params given. Can be set to :asc or :desc to match the direction specified
  #                     in the model.
  #
  def sort_link(column, options = {})
    # Options
    options = { :label => column.to_s.humanize.titleize,
                :default_order => :asc }.merge(options)

    if options[:is_default] && params[:column].nil? && params[:order].nil?
      is_current = true
      current_order = options[:is_default]
    else
      is_current = params[:column].eql?(column.to_s)
      current_order = params[:order]
    end

    # Add params and build new query string
    query = params.merge({
      :column => column,
      :order => is_current ? (current_order.to_s.eql?('asc') ? 'desc' : 'asc') : options[:default_order]
    })

    class_name = is_current ? "current #{query[:order]}" : options[:default_order]
    link_to(options[:label], query, :class => "#{column} #{class_name}")
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
    type = :notice if type.to_sym == :alert
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

  # Display all errors related to the +record+ for the +formtastic_form+.
  #
  # This is a workaround because Formtastic's default #sementic_errors behavior is crazy: it only displays errors for the record's "base", but not its fields. This is bad because if there's a validation error on a field that's far down on the screen or not included in the form, Formtastic will reject the user's attempt to submit the form, but display no errors. This is particularly bad with PaperClip, which uses validation on fields that are never listed in the form, and would otherwise not be displayed.
  def display_semantic_errors_for(formtastic_form, record)
    formtastic_form.semantic_errors *record.errors.keys
  end
end
