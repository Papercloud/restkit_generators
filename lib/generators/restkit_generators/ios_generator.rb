module RestkitGenerators
  class IosGenerator < Rails::Generators::NamedBase
    class_option :ios_path, type: :string, default: Rails.root

    protected

    def destination_path(filename=nil)
      File.join(File.expand_path(options[:ios_path]), 'Generated', 'gen', filename)
    end

    def embed_template(source, indent='')
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

  end
end