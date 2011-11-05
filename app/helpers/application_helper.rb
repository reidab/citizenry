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
      :error   => [ t('flowery.error1'), t('flowery.error2'), t('flowery.error3'), t('flowery.error4'), t('flowery.error5'), t('flowery.error6'), t('flowery.error7'),
                    t('flowery.error8'), t('flowery.error9'), t('flowery.error10'), t('flowery.error11'), t('flowery.error12') ],
      :success => [ t('flowery.success1'), t('flowery.success2'), t('flowery.success3'), t('flowery.success4'), t('flowery.success5'), t('flowery.success6'), t('flowery.success7'), t('flowery.success8') ],
      :notice  => [ t('flowery.notice1'), t('flowery.notice2'), t('flowery.notice3') ],
      :warning => [ t('flowery.warning1'), t('flowery.warning2'), t('flowery.warning3') ]
    }

    if flowery_vocabulary[type]
      return "#{flowery_vocabulary[type].sample}!"
    else
      return type.to_s.titleize
    end
  end

  # Display error messages for a +record+. If record has no errors, none are displayed.
  def display_errors_for(record)
    render :partial => "site/display_errors_for", :locals => {:record => record}
  end

  # Render HTML form tags for importing an image from a URL into a +record+'s
  # +field+ attribute.
  #
  # @example Render HTML for tags for importing an image from a URL into an +@person+ record's +#photo+ attribute:
  #   <%= import_image_from_url_tags_for @person, :photo %>
  def import_image_from_url_tags_for(form, record, field)
    render :partial => "site/import_image_from_url_tags", :locals => {:form => form, :record => record, :field => field}
  end
end
