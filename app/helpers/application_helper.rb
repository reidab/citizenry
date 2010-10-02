module ApplicationHelper
  def front_page?
    controller_name == 'site' && action_name == 'index'
  end

  def semantic_pluralize(count, singular, plural = nil)
    content_tag(:span, "#{count || 0} ", :class => 'count') +
      ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
  end
end
