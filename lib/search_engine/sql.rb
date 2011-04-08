require 'lib/search_engine/base'

class SearchEngine::Sql < SearchEngine::Base
  score false

  def self.add_sql_search_to(model, *fields)
    (class << model; self; end).instance_eval do
      # Return an Array of non-duplicate Event instances matching the search +query+..
      #
      # Options:
      # * :order => How to order the entries? Defaults to :date. Permitted values:
      #   * :date => Sort by date
      #   * :name => Sort by event title
      #   * :title => same as :name
      #   * :venue => Sort by venue title
      # * :limit => Maximum number of entries to return. Defaults to 50.
      define_method(:search) do |query, *opts|
        opts = opts.first
        opts ||= {}
        limit = opts[:limit]

        order = opts[:order] || "LOWER(#{self.table_name}.name) ASC"

        pagination_options = {}
        pagination_options[:page] = opts.delete(:page) if opts[:page].present?
        pagination_options[:per_page] = opts.delete(:per_page) if opts[:per_page].present?

        conditions_text = fields.map{|field| "LOWER(#{self.table_name}.#{field}) LIKE :like_query"}.join(" OR ")
        conditions = [conditions_text, {:like_query => "%#{query.downcase}%"}]

        results = self.all(:conditions => conditions, :order => order, :limit => limit)
        results = results.paginate(pagination_options) unless pagination_options.empty?

        return results
      end
    end
  end

  def self.add_searching_to(model)
    case model.new
    when Person
      add_sql_search_to(model, :name, :url, :bio, :location)
    when Company, Group, Project, ResourceLink
      add_sql_search_to(model, :name, :description, :url)
    else
      raise TypeError, "Unknown model class: #{model.name}"
    end
  end

  def self.search(query, options = {})
    SearchEngine.searchable_models.map {|model|
      model.to_s.constantize.search(query, options)
    }.flatten
  end
end
