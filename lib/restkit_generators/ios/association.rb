module RestkitGenerators
  module Ios
    class Association
      def initialize(association)
        @association = association
      end

      def model
        @model ||= Model.new(@association.klass.name)
      end

      def name
        @association.name
      end

      def klass
        @association.klass
      end

      def ios_deletion_rule
        @association.macro == :has_and_belongs_to_many ? "Nullify" : "Cascade"
      end

      def ios_association_type
        macro = @association.macro
        name = @association.klass.name

        type = ''
        if to_many?
          type = 'NSOrderedSet *'
        elsif [:belongs_to, :has_one].include? macro
          type = model.ios_class_name + " *"
        end

        raise "Don't know how to turn association '#{macro}' '#{name}' into an Objective-C property" unless type
        type
      end

      def inverse_of
        explicit_inverse = @association.options[:inverse_of]
        associated_class = @association.klass.name.constantize rescue nil

        if explicit_inverse
          associated_class.reflect_on_association(explicit_inverse)
        elsif associated_class
          guess_inverse(associated_class)
        end
      end

      def to_many?
        [:has_many, :has_and_belongs_to_many].include?(@association.macro)
      end

      def unpolymorphise(possible_models = [])
        return unless is_polymorphic?

        possible_models.select { |m|
          polymorphic_association_exists?(m.constantize)
        }.map { |m|
          association = OpenStruct.new({
            klass: m.constantize,
            active_record: @association.active_record,
            name: m.underscore.to_sym,
            macro: :belongs_to,
            options: {}
          })

          Association.new(association)
        }
      end

      def is_polymorphic?
        @association.options[:polymorphic]
      end

      private

      def polymorphic_association_exists?(model)
        singular_symbol = @association.active_record.name.demodulize.underscore.to_sym
        plural_symbol = @association.active_record.name.demodulize.pluralize.underscore.to_sym

        poly_association = model.reflect_on_association(singular_symbol) || model.reflect_on_association(plural_symbol)

        poly_association && poly_association.options[:as] == @association.name ? true : false
      end

      def guess_inverse(associated_class)
        ar_name = @association.active_record.name

        # Try a few guesses for the inverse.
        # The last four are in case of a namespaced class which would underscore as 'module_name/class_name'
        associated_class.reflect_on_association(ar_name.underscore.to_sym)\
        || associated_class.reflect_on_association(ar_name.pluralize.underscore.to_sym)\
        || associated_class.reflect_on_association(ar_name.underscore.gsub("/","_").to_sym)\
        || associated_class.reflect_on_association(ar_name.pluralize.underscore.gsub("/","_").to_sym)\
        || associated_class.reflect_on_association(ar_name.underscore.split("/").last.to_sym)\
        || associated_class.reflect_on_association(ar_name.pluralize.underscore.split("/").last.to_sym)
      end
    end
  end
end