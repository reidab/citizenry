require 'search_engine/base'

class SearchEngine::ThinkingSphinx < SearchEngine::Base
  score true

  def self.add_searching_to(model)
    model.class_eval do
      include ThinkingSphinx::Scopes
    end

    case model.new
    when Person
      ThinkingSphinx::Index.define :person, :with => :active_record, :delta => true do
        indexes :name, :sortable => true
        indexes :bio
        indexes :url
        indexes :location
        indexes taggings.tag.name, :as => :tags

        has :created_at, :updated_at
      end
    when Company
      ThinkingSphinx::Index.define :company, :with => :active_record, :delta => true do
        indexes :name, :sortable => true
        indexes :description
        indexes :url
        indexes :address
        indexes taggings.tag.name, :as => :tags

        has :created_at, :updated_at
      end
    when Group, Project
      ThinkingSphinx::Index.define model.to_s.underscore.to_sym, :with => :active_record, :delta => true do
        indexes :name, :sortable => true
        indexes :description
        indexes :url
        indexes taggings.tag.name, :as => :tags

        has :created_at, :updated_at
      end
    when ResourceLink
      ThinkingSphinx::Index.define :resource_link, :with => :active_record, :delta => true do
        indexes :name, :sortable => true
        indexes :description
        indexes :url

        has :created_at, :updated_at
      end
    else
      raise TypeError, "Unknown model class: #{model.name}"
    end
  end

  def self.search(query, options = {})
    ThinkingSphinx.search(Riddle::Query.escape(query), options)
  end
end
