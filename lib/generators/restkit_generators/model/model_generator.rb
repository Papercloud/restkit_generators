module RestkitGenerators
  class ModelGenerator < IosGenerator
    source_root File.expand_path('../templates', __FILE__)

    class_option :include_timestamps, type: :boolean, default: false

    def generate_model_classes
      template "interface.h.erb",       destination_path("#{filename}.h")
      template "implementation.m.erb",  destination_path("#{filename}.m")
    end

    def generate_shared_header_inclusion
      create_file destination_path("Generated.h"), skip: true
      append_file destination_path("Generated.h"), "@class #{overwrite_filename};\n"
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
      model_name
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

    def has_many_associations
      associations.select{|a| macro_to_many?(a.macro) }
    end

    def belongs_to_associations
      associations.select{|a| not macro_to_many?(a.macro) }
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

    def macro_to_many?(macro)
      (macro == :has_many or macro == :has_and_belongs_to_many)
    end

  end
end