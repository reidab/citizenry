module HeySorty
  module NamedScope
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def sortable(column = :id, order = :asc)
        # Quit if table doesn't exist so that migrations can be run.
        return false unless connection.table_exists?(self.name.tableize)

        # Defaults
        @options = { :column => column.to_s, :order => order.to_s }
        
        # Available options
        valid_orders = %w[asc desc]
        valid_columns = columns.map(&:name)
        valid_columns += reflections.map{|r| r[1].options[:polymorphic] === true ? nil : r[1].class_name.constantize.columns.map{|c| "#{r[0]}.#{c.name}"}}.flatten
               
        # Check arguments
        raise InvalidColumnName unless valid_columns.include?(@options[:column])
        raise InvalidOrderValue unless valid_orders.include?(@options[:order])
      
        # Define named scope
        scope :sorty, lambda { |params|
          # Sorting attributes
          column = params[:column] || @options[:column]
          order = params[:order] || @options[:order]
          
          # Check for errors
          raise ArgumentError unless valid_columns.include?(column) && valid_orders.include?(order)
          
          # Load in association
          if column.include?('.')
            # Split column into reflection name and column
            reflection_name, column = column.split('.')
            reflection_name = reflection_name.to_sym
            
            # Calculate the new column name
            table = reflections[reflection_name].table_name
            column = "#{table}.#{column}"
            
            # Add the association
            associations = [reflection_name]
          end
        
          # Return order hash
          { :order => [column, order].delete_if(&:blank?).join(' '), :include => associations } 
        }
      
        # Sortable
        class_eval <<-EOF
          def self.sortable?; true; end
        EOF
      end
      
      def sortable?; false; end
    end
  end
end

ActiveRecord::Base.send(:include, HeySorty::NamedScope)
