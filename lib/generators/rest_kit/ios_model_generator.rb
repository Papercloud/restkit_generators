module RestKit
  class IosModelGenerator < Rails::Generators::NamedBase
    class_option :ios_path, type: :string, default: Rails.root
    class_option :include_timestamps, type: :boolean, default: false

    protected

    def destination_path(filename=nil)
      File.join(File.expand_path(options[:ios_path]), 'Generated', 'gen', filename)
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

      return Dir.glob(File.join(File.expand_path(ios_project_root), "**/#{filename}")).length > 0
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
      name.capitalize
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

    def columns
      columns = model.columns
      columns = columns.select{|c| not c.name.in? ["created_at", "updated_at"]} if not options[:skip_namespace]
      columns
    end

  end
end