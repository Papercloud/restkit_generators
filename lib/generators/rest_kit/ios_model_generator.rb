require_relative './helpers'
require 'ostruct'

module RestKit
  # Abstract base class for iOS Mapping, Model and Route generators.
  class IosModelGenerator < Rails::Generators::NamedBase
    class_option :ios_path, type: :string, required: true
    class_option :include_timestamps, type: :boolean, default: false
    class_option :skip_pod_install, type: :boolean, required: false, default: false
    class_option :exclude_columns, type: :string, required: false, description: "Comma separated list of columns to exclude"

    protected

    def destination_path(filename=nil)
      File.join(File.expand_path(options[:ios_path]), 'Generated', filename)
    end

    def embed_template(source, indent='', binding=binding)
      template = File.join(self.class.source_root, source)
      ERB.new(IO.read(template), nil, '-').result(binding).gsub(/^/, indent)
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
      name.to_s.singularize.camelize
    end

    def ios_base_class_name(class_name=nil)
      "_" + ios_class_name(class_name || model_name)
    end

    def model_name
      name.camelize
    end

    def model
      model_name.constantize
    end

    def associations
      model.reflect_on_all_associations
    end

    def has_many_associations
      associations.select{|a| macro_to_many?(a.macro) }
    end

    def belongs_to_associations
      associations.select{|a| not macro_to_many?(a.macro) }
    end

    def macro_to_many?(macro)
      (macro == :has_many or macro == :has_and_belongs_to_many)
    end

    def excluded_columns
      excluded_columns = []
      excluded_columns += ["created_at", "updated_at"] unless options[:include_timestamps]
      excluded_columns += options[:exclude_columns].split(",") if options[:exclude_columns]
      excluded_columns
    end

    def columns
      columns = model.columns
      columns = columns.select{|c| not c.name.in? excluded_columns }
      columns += additional_columns
      columns
    end

    # @param model_name [String] The model's name
    # @return [Array<String>] Columns to exclude for this model. Returns an empty array if none.
    def excluded_columns_for_model(model_name)
      config.fetch(:models, {}).fetch(model_name, {}).fetch(:exclude, [])
    end

    # @param model_name [String] The model's name
    # @return [Array<Object>] Columns to add for this model (iOS config file should define name and type).
    # Returns an empty array if none.
    def additional_columns
      additions = config.fetch(:models, {}).fetch(model_name, {}).fetch(:additions, [])

      columns = []
      additions.each do |a|
        columns << photo = OpenStruct.new(
          name: a[:name],
          type: a[:type]
        )
      end

      columns
    end
    include RestKit::Helpers

  end
end