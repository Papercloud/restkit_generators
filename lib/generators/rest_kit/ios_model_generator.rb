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

    def model
      @model ||= RestkitGenerators::Ios::Model.new(name, config)
    end

    def ios_attr_name(attr_name)
      { "id" => model.id_name }[attr_name.to_s] ||= attr_name.to_s.camelize(:lower)
    end

    def associations
      associations = model.associations.reject{ |a| excluded_columns.include?(a.name.to_s) }
      associations = associations.map{ |a| RestkitGenerators::Ios::Association.new(a, config) }
      associations = associations.map{ |a| a.is_polymorphic? ? a.unpolymorphise(model_class_names) : a }
      associations.flatten
    end

    def has_many_associations
      associations.select{ |a| a.to_many? }
    end

    def belongs_to_associations
      associations.select{ |a| !a.to_many? }
    end

    def excluded_columns
      excluded_columns = []
      excluded_columns += ["created_at", "updated_at"] unless options[:include_timestamps]
      excluded_columns += options[:exclude_columns].split(",") if options[:exclude_columns]

      excluded_columns
    end

    def columns
      model.columns(excluded_columns)
    end

    def ios_class_name(class_name)
      class_name.singularize.camelize.gsub(/[:]/, '')
    end

    def ios_base_class_name(class_name)
      "_#{ios_class_name(class_name)}"
    end

    include RestKit::Helpers
  end
end