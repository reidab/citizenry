module HeySortyHelpers
  def sorty(column, options = {})
    # Options
    options = { :label => column.to_s.humanize.titleize }.merge(options)
    
    # Add params
    query = params.merge({
      :column => column,
      :order => (params[:order].eql?('asc') ? 'desc' : 'asc')
    })
  
    # Build new query string
    class_name = query[:column].eql?(column.to_s) ? query[:order] : 'asc'
    link_to(options[:label], query, :class => class_name)
  end
end

ActionView::Base.send(:include, HeySortyHelpers)