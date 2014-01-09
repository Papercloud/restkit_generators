module RestkitGenerators
  class MappingGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def serializer_name
      if name.downcase.include? "serializer"
        name.capitalize
      else
        name.capitalize + "Serializer"
      end
    end

    def generate_mapping_protocol
      template "interface.h.erb",       "tmp/restkit_generators/RKManagedObject+#{serializer_name}Mapping.h"
      template "implementation.m.erb",  "tmp/restkit_generators/RKManagedObject+#{serializer_name}Mapping.m"
    end
  end
end