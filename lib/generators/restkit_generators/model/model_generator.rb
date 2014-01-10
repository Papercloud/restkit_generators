module RestkitGenerators
  class ModelGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    class_option :include_timestamps, type: :boolean, default: false

    def generate_mapping_protocol
      template "interface.h.erb",       "gen/#{filename}.h"
      template "implementation.m.erb",  "gen/#{filename}.m"
    end

    private

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
      if macro == :has_many or macro == :has_and_belongs_to_many
        type = 'NSOrderedSet *'
      elsif macro == :belongs_to
        type = ios_class_name(name) + " *"
      end
      raise "Don't know how to turn association '#{macro}` '#{name}' into an Objective-C property" unless type
      type
    end

  end
end