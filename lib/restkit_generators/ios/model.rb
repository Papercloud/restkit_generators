module RestkitGenerators
  module Ios
    class Model
      attr_reader :model_name

      def initialize(model_name, options={})
        @model_name = model_name.camelize
        @options = options
      end

      def id_name
        "primaryKey"
      end

      def ios_class_name
        @ios_class_name ||= options['drop_namespace'] ? @model_name.demodulize : @model_name.gsub(/[:]/, '')
      end

      def ios_base_class_name
        "_#{ios_class_name}"
      end

      def entity_name
        ios_class_name
      end

      def model
        @model_name.constantize
      end

      def associations
        associations = model.reflect_on_all_associations - parent_associations
        associations = associations.reject{ |a| excluded_columns.include?(a.name.to_s) }
        associations = associations.map{ |a| RestkitGenerators::Ios::Association.new(a) }
        associations = associations.map{ |a| a.is_polymorphic? ? a.unpolymorphise(RestkitGenerators.model_class_names) : a }
        associations.flatten
      end

      def columns
        columns = model.columns

        columns = columns.reject{ |c| c.name.in?(excluded_columns) }
        columns = columns.reject{ |c| c.name.in?(parent_columns.map(&:name)) }

        columns.concat(additional_columns)
      end

      def non_persisted_columns
        RestkitGenerators.config.non_persisted_columns_for_model(@model_name)
      end

      def validators
        @validators ||= model.validators
      end

      def presence_validators
        presence_validators = validators.find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }

        presence_validators.present? ? presence_validators.attributes.map(&:to_s) : []
      end

      def has_many_associations
        @has_many_associations ||= associations.select{ |a| a.to_many? }
      end

      def belongs_to_associations
        @belongs_to_associations ||= associations.select{ |a| a.belongs_to? }
      end

      def has_one_associations
        @has_one_associations ||= associations.select{ |a| a.has_one? }
      end

      private

      def excluded_columns
        excluded_columns = [].tap do |column_array|
          column_array.concat(["created_at", "updated_at"]) unless options[:include_timestamps]
          column_array.concat(options[:exclude_columns].split(",").map(&:strip)) if options[:exclude_columns]
        end
      end

      def additional_columns
        RestkitGenerators.config.additional_columns_for_model(@model_name)
      end

      def options
        RestkitGenerators.config.options_for_model(@model_name).merge(@options)
      end

      def parent_class
        model.base_class != model ? model.base_class : nil
      end

      def parent_columns
        return [] if parent_class.nil? || options['honour_parent'] == false

        parent_class.columns
      end

      def parent_associations
        return [] if parent_class.nil? || options['honour_parent'] == false

        parent_class.reflect_on_all_associations
      end
    end
  end
end
