module RestkitGenerators
  class MappingGenerator < IosGenerator
    source_root File.expand_path('../templates', __FILE__)

    def generate_mapping_protocol
      template "interface.h.erb",       destination_path("#{filename}.h")
      template "implementation.m.erb",  destination_path("#{filename}.m")
    end

    private

    def filename
      "RKObjectMapping+" + category_name
    end

    def category_name
      serializer_name + "Mapping"
    end

    def serializer_name
      if name.downcase.include? "serializer"
        name.capitalize
      else
        name.capitalize + "Serializer"
      end
    end

    def serializer
      serializer_name.constantize
    end

    def included_has_many_associations
      serializer.schema[:associations].select{|k,v| v.keys.first == :has_many || v.keys.first == :has_and_belongs_to_many }.keys
    end

    def included_belongs_to_associations
      serializer.schema[:associations].select{|k,v| v.keys.first == :belongs_to }.keys
    end

  end
end