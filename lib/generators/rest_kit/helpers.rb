require_relative './config'

module RestKit
  module Helpers

    def pod_init
      puts "No Podfile found, generating one for you!"

      Dir.chdir(options[:ios_path]) {
        Bundler.with_clean_env {
          system 'pod init'
        }
      }
    end

    def pod_install
      Dir.chdir(options[:ios_path]) {
        Bundler.with_clean_env {
          system 'pod install --no-repo-update'
        }
      }
    end

    def config
      @config ||= Config.new(config_file_path)
    end

    # @return [Array<String>] All model class names in the Rails project
    def all_model_class_names
      @all_model_class_names ||= ->{
        Dir[Rails.root.join("app/models/**/*.rb")].each {|file| require file }
        ActiveRecord::Base.descendants.map(&:name)
      }.call
    end

    # @return [Array<String>] Model class names that we want to exclude, according to the config file.
    def excluded_model_class_names
      config.excluded_models
    end

    # @return [Array<String] Model class names that we want included in the SDK.
    def model_class_names
      all_model_class_names - excluded_model_class_names
    end

    # Path of the YAML config file used to persist settings for excluding classes between runs
    # of this generator.
    # @return [String] Absolute path to the config file.
    def config_file_path
      Rails.root.join('.ios_sdk_config.yml')
    end

    def association_exists?(model, association)
      singular_symbol = association.active_record.name.underscore.to_sym
      plural_symbol = association.active_record.name.pluralize.underscore.to_sym

      model.reflect_on_association(singular_symbol) || model.reflect_on_association(plural_symbol) ? true : false
    end

  end
end