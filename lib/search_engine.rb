# = SearchEngine
#
# The SearchEngine class and associated logic provide a pluggable search engine
# for Citizenry. It was originally swiped from Igal's work on Calagator.
#
# If you're administering a Citizenry instance and are looking for instructions
# on configuring search, see the `INSTALL.md` file's "Search engine" section.
#
# == Things related to searching
#
# === Secrets
#
# Administrators of a Citizenry instance can specify which search engine to use
# by setting the `search_engine` field in the `config/settings.yml` to the name
# of the search engine to use, e.g. `sphinx`. If one isn't set, a sensible
# default search engine is used.
#
# === SearchEngine
#
# This module activates a search engine implementation, queries its
# capabilities, and adds searching to models, e.g.:
#
#   class MyModel < ActiveRecord::Base
#     include SearchEngine
#   end
#
# ===  SearchEngine::Base
#
# Base class for search engine implementations.
#
# === SearchEngine implementations, e.g. SearchEngine::Sunspot
#
# These classes describe the behavior of a particular search engine. These
# inject code into models that `include SearchEngine`.
#
# == Environment
#
# The `config/environment.rb` activates a search engine implementation, and
# specifies, loads and configures any libraries it requires.
module SearchEngine
  @@kind = :sql
  @@searchable_models = Set.new

  # Add searching to the ActiveRecord +model+ class, e.g. Event.
  def self.included(model)
    if ActiveRecord::Base.connection.tables.include?(model.table_name)
      @@searchable_models << model.name.to_sym
      return implementation.add_searching_to(model)
    end
  end

  # Set kind of search engine to use, e.g. :acts_as_solr.
  def self.kind=(value)
    case value
    when nil, ''
      @@kind = :sql
    else
      @@kind = value.to_s.underscore.to_sym
    end

    return @@kind
  end

  # Return kind of search engine to use, e.g. :thinking_sphinx.
  def self.kind
    return @@kind
  end

  def self.searchable_models
    return @@searchable_models
  end

  # Return class to use as search engine.
  def self.implementation
    begin
      return "SearchEngine::#{self.kind.to_s.classify}".constantize
    rescue NameError
      raise ArgumentError, "Invalid search engine specified in 'config/settings.yml': #{self.kind}"
    end
  end

  # Does the current search engine provide a score?
  def self.score?
    return self.implementation.score?
  end

  def self.search(query, options = {})
    return self.implementation.search(query, options)
  end
end
