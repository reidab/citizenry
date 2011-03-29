require 'hey_sorty/named_scope'
require 'hey_sorty/helpers'

module HeySorty
  class InvalidColumnName < StandardError; end
  class InvalidOrderValue < StandardError; end
  class ArgumentError < StandardError; end
end