module RestkitGenerators
  module Ios
    class Model
      attr_reader :model_name

      def initialize(model_name, config)
        @model_name = model_name.camelize
        @config = config
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

      def parent_class
        model.base_class != model ? model.base_class : nil
      end

      def parent_columns
        return [] if parent_class.nil?

        parent_class.columns
      end

      def associations
        model.reflect_on_all_associations
      end

      def columns(exclusions = [])
        columns = model.columns

        columns = columns.reject{ |c| c.name.in?(exclusions) } if exclusions.any?
        columns = columns.reject{ |c| c.name.in?(excluded_columns) } if exclusions.empty?
        columns = columns.reject{ |c| c.name.in?(parent_columns.map(&:name)) }

        columns.concat(additional_columns)
      end

      def non_persisted_columns
        @config.non_persisted_columns_for_model(@model_name)
      end

      def validators
        @validators ||= model.validators
      end

      def presence_validators
        presence_validators = validators.find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }

        presence_validators.present? ? presence_validators.attributes.map(&:to_s) : []
      end

      private

      def excluded_columns
        @config.excluded_columns_for_model(@model_name)
      end

      def additional_columns
        @config.additional_columns_for_model(@model_name)
      end

      def options
        @config.options_for_model(@model_name)
      end
    end
  end
end
