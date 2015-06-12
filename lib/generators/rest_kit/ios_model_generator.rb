require_relative './helpers'

module RestKit
  # Abstract base class for iOS Mapping, Model and Route generators.
  class IosModelGenerator < Rails::Generators::NamedBase
    class_option :ios_path, type: :string, required: true
    class_option :include_timestamps, type: :boolean, default: false
    class_option :skip_pod_install, type: :boolean, required: false, default: false
    class_option :exclude_columns, type: :string, required: false, description: "Comma separated list of columns to exclude"
    class_option :use_swift, type: :boolean, required: false, default: false, description: "Generate a swift version of the class instead of Objective-C"

    protected

    def destination_path(filename=nil)
      File.join(File.expand_path(options[:ios_path]), 'Generated', filename)
    end

    def embed_template(source, indent='', binding_override=nil)
      template = File.join(self.class.source_root, source)
      ERB.new(IO.read(template), nil, '-').result(binding_override || binding).gsub(/^/, indent)
    end

    def user_overwritten?
      ios_includes_file? "#{overwrite_filename}.h"
    end

    def ios_includes_file?(filename)
      ios_project_root = options[:ios_path]
      raise "Couldn't find iOS project at #{ios_project_root}" unless File.directory? File.expand_path(ios_project_root)

      return Dir[File.join(File.expand_path(ios_project_root), "**/#{filename}")].reject{ |f|
        f.include? File.join(File.expand_path(ios_project_root), "Generated") \
        or f.include? File.join(File.expand_path(ios_project_root), "Pods")
      }.length > 0
    end

    def ios_attr_name(attr_name)
      { "id" => id_name }[attr_name.to_s] ||= attr_name.to_s.camelize(:lower)
    end

    def id_name
      "primaryKey"
    end

    def ios_class_name(name)
      name.to_s.singularize.camelize.gsub(/[:]/, '')
    end

    def ios_base_class_name(class_name=nil)
      "_" + ios_class_name(class_name || entity_name)
    end

    def model_name
      name.camelize
    end

    def entity_name
      model_name.gsub(/[:]/, '')
    end

    def model
      model_name.constantize
    end

    def associations
      associations = model.reflect_on_all_associations.reject{ |a| excluded_columns.include?(a.name.to_s) }
      associations.map! { |a| a.options[:polymorphic] ? unpolymorphise(a) : a }
      associations.flatten
    end

    def unpolymorphise(association)
      model_class_names.select { |m|
        polymorphic_association_exists?(m.constantize, association)
      }.map { |m|
        OpenStruct.new({
          klass: m.constantize,
          active_record: association.active_record,
          name: m.underscore.to_sym,
          macro: :belongs_to,
          options: {}
        })
      }
    end

    def has_many_associations
      associations.select{ |a| macro_to_many?(a.macro) }
    end

    def belongs_to_associations
      associations.select{ |a| not macro_to_many?(a.macro) }
    end

    def ios_deletion_rule(association)
      association.macro == :has_and_belongs_to_many ? "Nullify" : "Cascade"
    end

    def macro_to_many?(macro)
      (macro == :has_many or macro == :has_and_belongs_to_many)
    end

    def excluded_columns
      excluded_columns = []
      excluded_columns += ["created_at", "updated_at"] unless include_timestamps?

      if options[:exclude_columns]
        excluded_columns += options[:exclude_columns].split(",") if options[:exclude_columns]
      else
        excluded_columns += excluded_columns_for_model(model_name)
      end

      excluded_columns
    end

    def columns
      columns = model.columns

      if parent_class
        columns.reject!{ |c| c.name.in?(parent_class.columns.map(&:name)) }
      end

      columns = columns.select{|c| not c.name.in? excluded_columns }
      columns += additional_columns
      columns
    end

    def parent_class
      model.base_class != model ? model.base_class : nil
    end

    def is_abstract?
      # binding.pry
    end

    def include_timestamps?
      options[:include_timestamps] || config.options_for_model(model_name)[:include_timestamps]
    end

    def excluded_columns_for_model(model_name)
      config.excluded_columns_for_model(model_name)
    end

    def additional_columns
      config.additional_columns_for_model(model_name)
    end

    include RestKit::Helpers

  end
end