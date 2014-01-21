module RestKit
  class ModelGenerator < IosModelGenerator
    source_root File.expand_path('../templates', __FILE__)

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
        gsub_file(destination_path("Generated.h"), /#import "Post.h"\n/, '')
      end
      
      inject_into_file destination_path("Generated.h"), after: "// Header includes\n" do
        "#import \"#{filename}.h\"\n"
      end
    end

    def generate_core_data_schema
      empty_directory destination_path("DataModel.xcdatamodeld"), skip: true
      empty_directory destination_path("DataModel.xcdatamodeld/DataModel.xcdatamodel"), skip: true
      template "core_data.xcdatamodeld.erb", destination_path("DataModel.xcdatamodeld/DataModel.xcdatamodel/contents"), skip: true
      
      # Inject entity
      inject_into_file destination_path("DataModel.xcdatamodeld/DataModel.xcdatamodel/contents"), before: "<elements>" do |config|
        embed_template("entity.xml.erb", "    ")
      end

      # Add to elements list
      inject_into_file destination_path("DataModel.xcdatamodeld/DataModel.xcdatamodel/contents"), before: "</elements>" do |config|
        "<element name=\"#{model_name}\" positionX=\"0\" positionY=\"0\" width=\"0\" height=\"0\"/>\n"
      end
    end

    private

    def destination_path(path)
      super(File.join("Models", path))
    end

    def core_data_type(ruby_type)
      type = {
        "integer" => "Integer 32",
        "string" => "String",
        "text" => "String",
        "date" => "Date"
      }[ruby_type.to_s]
      raise "Don't know how to turn '#{ruby_type}' into a Core Data type" unless type
      type
    end

    def overwrite_filename
      ios_class_name(model_name)
    end

    def filename
      ios_base_class_name
    end

    def inverse_of(association)
      explicit_inverse = association.options[:inverse_of]
      associated_class = association.class_name.constantize 
      if explicit_inverse
        associated_class.reflect_on_assocation(explicit_inverse)
      else
        associated_class.reflect_on_association(association.active_record.name.underscore.to_sym) || associated_class.reflect_on_association(association.active_record.name.pluralize.underscore.to_sym)
      end
    end

    def ios_type(ruby_type)
      type = {
        "integer" => "NSNumber *",
        "string" => "NSString *",
        "text" => "NSString *",
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

  end
end