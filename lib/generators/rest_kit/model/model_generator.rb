module RestKit
  class ModelGenerator < IosModelGenerator
    source_root File.expand_path('../templates', __FILE__)
    class_option :data_model_path, type: :string, required: false, description: "Path to an existing /contents file with an xcdatamodel. Usually for your most recent model version."

    def generate_model_classes
      template "interface.h.erb",       destination_path("#{filename}.h")
      template "implementation.m.erb",  destination_path("#{filename}.m")
    end

    def generate_stub_model_class
      if not user_overwritten?
        template "temp_scaffold_interface.h.erb",       destination_path("#{overwrite_filename}.h")
        template "temp_scaffold_implementation.m.erb",  destination_path("#{overwrite_filename}.m")
      else
        remove_file destination_path("#{overwrite_filename}.h")
        remove_file destination_path("#{overwrite_filename}.m")
      end
    end

    def generate_shared_header_inclusion
      template "shared_header.h.erb", destination_path("Generated.h"), skip: true

      inject_into_file destination_path("Generated.h"), after: "// Forward class declarations\n" do
        "@class #{filename};\n"
      end

      if not user_overwritten?
        inject_into_file destination_path("Generated.h"), after: "// Temporary stub headers.\n" do
          "#import \"#{overwrite_filename}.h\"\n"
        end
      else
        gsub_file(destination_path("Generated.h"), /#import "#{overwrite_filename}.h"\n/, '')
      end

      inject_into_file destination_path("Generated.h"), after: "// Header includes\n" do
        "#import \"#{filename}.h\"\n"
      end
    end

    def generate_core_data_schema

      # See if we're altering an existing data model.
      data_model_path = options[:data_model_path]

      if not data_model_path
        empty_directory destination_path("DataModel.xcdatamodeld"), skip: true
        empty_directory destination_path("DataModel.xcdatamodeld/DataModel.xcdatamodel"), skip: true
        template "core_data.xcdatamodeld.erb", destination_path("DataModel.xcdatamodeld/DataModel.xcdatamodel/contents"), skip: true
        data_model_path = destination_path("DataModel.xcdatamodeld/DataModel.xcdatamodel/contents")
      else
        data_model_path = File.join(File.expand_path(options[:ios_path]), data_model_path)
      end

      # Inject entity
      inject_into_file data_model_path, before: "<elements>" do |config|
        embed_template("entity.xml.erb", "    ")
      end

      # Add to elements list
      inject_into_file data_model_path, before: "</elements>" do |config|
        "<element name=\"#{model.entity_name}\" positionX=\"0\" positionY=\"0\" width=\"0\" height=\"0\"/>\n"
      end
    end

    def update_project
      pod_install unless options[:skip_pod_install]
    end

    private

    def destination_path(path)
      super(File.join("Models", path))
    end

    def core_data_type(column)
      return "String" if column.name.end_with?('_id') || column.name == 'id'

      type = {
        "integer" => "Integer 32",
        "string" => "String",
        "text" => "String",
        "date" => "Date",
        "datetime" => "Date",
        "boolean" => "Boolean",
        "inet" => "String",
        "float" => "Float",
        "json" => "String",
        "uuid" => "String"
      }[column.type.to_s]
      raise "Don't know how to turn '#{column.type}' into a Core Data type" unless type
      type
    end

    def overwrite_filename
      model.ios_class_name
    end

    def filename
      model.ios_base_class_name
    end

    def ios_type(column)
      return "NSString *" if column.name.end_with?('_id') || column.name == 'id'

      type = {
        "integer" => "NSNumber *",
        "string" => "NSString *",
        "text" => "NSString *",
        "date" => "NSDate *",
        "datetime" => "NSDate *",
        "boolean" => "BOOL ",
        "inet" => "NSString *",
        "float" => "NSDecimalNumber *",
        "json" => "NSString *",
        "uuid" => "NSString *"
      }[column.type.to_s]
      raise "Don't know how to turn '#{column.type}' into an Objective-C type" unless type
      type
    end
  end
end