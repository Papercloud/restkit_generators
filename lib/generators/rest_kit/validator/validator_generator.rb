module RestKit
  class ValidatorGenerator < IosModelGenerator
    source_root File.expand_path('../templates', __FILE__)

    def generate_validator_class
      return if Pathname.new(destination_path("#{validator_filename}.h")).exist?

      template 'validator.h.erb', destination_path("#{validator_filename}.h")
      template 'validator.m.erb', destination_path("#{validator_filename}.m")
    end

    def generate_validator_extension
      if use_swift
        template "extension.swift.erb",   destination_path("#{filename}.swift")
      else
        template "interface.h.erb",       destination_path("#{filename}.h")
        template "implementation.m.erb",  destination_path("#{filename}.m")
      end
    end

    def update_project
      pod_install unless options[:skip_pod_install]
    end

    private

    def destination_path(path)
      super(File.join("Validators", path))
    end

    def filename
      "#{model.ios_base_class_name}+Validation"
    end

    def use_swift
      options[:use_swift]
    end

    def category_name
      'Validation'
    end

    def validator_filename
      'RKGValidator'
    end
  end
end