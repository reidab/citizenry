require 'lib/search_engine/base'

class SearchEngine::ThinkingSphinx < SearchEngine::Base
  score true

  def self.add_searching_to(model)
    case model.new
    when Person
      model.class_eval do
        define_index do
          indexes :name, :sortable => true
          indexes :bio
          indexes :url
          indexes :location
          indexes technology_taggings.tag.name, :as => :technologies
          indexes tag_taggings.tag.name, :as => :tags

          has :created_at, :updated_at
          set_property :delta => true
        end
      end
    when Company
      model.class_eval do
        define_index do
          indexes :name, :sortable => true
          indexes :description
          indexes :url
          indexes :address
          indexes technology_taggings.tag.name, :as => :technologies
          indexes tag_taggings.tag.name, :as => :tags

          has :created_at, :updated_at
          set_property :delta => true
        end
      end
    when Group, Project, ResourceLink
      model.class_eval do
        define_index do
          indexes :name, :sortable => true
          indexes :description
          indexes :url
          indexes technology_taggings.tag.name, :as => :technologies
          indexes tag_taggings.tag.name, :as => :tags

          has :created_at, :updated_at
          set_property :delta => true
        end
      end
    when ResourceLink
      model.class_eval do
        define_index do
          indexes :name, :sortable => true
          indexes :description
          indexes :url

          has :created_at, :updated_at
          set_property :delta => true
        end
      end
    else
      raise TypeError, "Unknown model class: #{model.name}"
    end
  end

  def self.search(query, options = {})
    ThinkingSphinx.search(query, options)
  end
end
