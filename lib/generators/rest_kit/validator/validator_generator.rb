module RestKit
  class ValidatorGenerator < IosModelGenerator
    source_root File.expand_path('../templates', __FILE__)

    def generate_validator_extension
      if use_swift
        template "extension.swift.erb",   destination_path("#{filename}.swift")
      else
        template "interface.h.erb",       destination_path("#{filename}.h")
        template "implementation.m.erb",  destination_path("#{filename}.m")
      end
    end

    private

    def destination_path(path)
      super(File.join("Validators", path))
    end

    def filename
      "#{ios_base_class_name}+Validation"
    end

    def use_swift
      options[:use_swift]
    end

    def validators
      model.validators
    end

    def presence_validations
      presence_validator = validators.find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }

      presence_validator.try(:attributes).map(&:to_s) || []
    end

  end
end