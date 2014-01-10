module RestkitGenerators
  class ModelGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    class_option :include_timestamps, type: :boolean, default: false

    def generate_model_classes
      template "interface.h.erb",       "gen/#{filename}.h"
      template "implementation.m.erb",  "gen/#{filename}.m"
    end

    def generate_shared_header_inclusion
      create_file "gen/Generated.h", skip: true
      append_file "gen/Generated.h", "#include \"#{overwrite_filename}.h\""
    end

    def generate_core_data_schema
      empty_directory "gen/DataModel.xcdatamodeld"
      empty_directory "gen/DataModel.xcdatamodeld/DataModel.xcdatamodel"
      template "core_data.xcdatamodeld.erb", "gen/DataModel.xcdatamodeld/DataModel.xcdatamodel/contents", skip: true
      
      # Inject entity
      inject_into_file "gen/DataModel.xcdatamodeld/DataModel.xcdatamodel/contents", before: "<elements>" do |config|
        embed_template("entity.xml.erb", "    ")
      end

      # Add to elements list
      inject_into_file "gen/DataModel.xcdatamodeld/DataModel.xcdatamodel/contents", before: "</elements>" do |config|
        "<element name=\"#{model_name}\" positionX=\"0\" positionY=\"0\" width=\"0\" height=\"0\"/>\n"
      end
    end

    private

    def core_data_type(ruby_type)
      type = {
        "integer" => "Integer 32",
        "string" => "String",
        "date" => "Date"
      }[ruby_type.to_s]
      raise "Don't know how to turn '#{ruby_type}' into a Core Data type" unless type
      type
    end

    def embed_template(source, indent='')
      template = File.join(self.class.source_root, source)
      ERB.new(IO.read(template), nil, '-').result(binding).gsub(/^/, indent)
    end

    def user_overwritten?
      ios_includes_file? "#{overwrite_filename}.h"
    end

    def overwrite_filename
      model_name
    end

    def ios_includes_file?(filename)
      # TODO: This will need to be a setting. Maybe a dotfile that isn't checked in to source control.
      ios_project_root = File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy")
      raise "Couldn't find iOS project at #{ios_project_root}" unless File.directory? ios_project_root

      return Dir.glob("./**/#{filename}").length > 0
    end

    def filename
      "_#{model_name}"
    end

    def model_name
      name.capitalize
    end

    def model
      model_name.constantize
    end

    def columns
      columns = model.columns
      columns = columns.select{|c| not c.name.in? ["created_at", "updated_at"]} if not options[:skip_namespace]
      columns
    end

    def associations
      model.reflect_on_all_associations
    end

    def ios_attr_name(attr_name)
      { "id" => id_name }[attr_name.to_s] ||= attr_name.to_s.camelize(:lower)
    end

    def id_name
      "primaryKey"
    end

    def ios_class_name(name)
      name.to_s.camelize
    end

    def ios_type(ruby_type)
      type = {
        "integer" => "NSNumber *",
        "string" => "NSString *",
        "date" => "NSDate *",
        "datetime" => "NSDate *"
      }[ruby_type.to_s]
      raise "Don't know how to turn '#{ruby_type}' into an Objective-C type" unless type
      type
    end

    def ios_association_type(association)
      macro = association.macro
      name = association.name

      type = ''
      if macro_to_many? macro
        type = 'NSOrderedSet *'
      elsif macro == :belongs_to
        type = ios_class_name(name) + " *"
      end
      raise "Don't know how to turn association '#{macro}` '#{name}' into an Objective-C property" unless type
      type
    end

    def macro_to_many?(macro)
      (macro == :has_many or macro == :has_and_belongs_to_many)
    end

  end
end