module RestKit
  class MappingGenerator < IosModelGenerator
    source_root File.expand_path('../templates', __FILE__)

    def generate_protocol
      return if Pathname.new(destination_path('MappingProtocol.h')).exist?

      template 'protocol.h.erb', destination_path('MappingProtocol.h')
    end

    def generate_mapping_protocol
      template "interface.h.erb",       destination_path("#{filename}.h")
      template "implementation.m.erb",  destination_path("#{filename}.m")
    end

    def update_project
      pod_install unless options[:skip_pod_install]
    end

    private

    def destination_path(path)
      super(File.join("Mappings", path))
    end

    def filename
      model.ios_base_class_name + "+" + category_name
    end

    def category_name
      "Mapping"
    end
  end
end