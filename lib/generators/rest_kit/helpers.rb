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
      @config ||= RestkitGenerators::Config.new(config_file_path)
    end

    # @return [Array<String>] All model class names in the Rails project
    def all_model_class_names
      @all_model_class_names ||= -> {
        Rails.application.eager_load!

        models = Dir["#{Rails.root}/app/models/**/*.rb"].map do |m|
          mp = m.reverse.chomp("#{Rails.root}/app/models/".reverse).reverse
          mp.chomp('.rb').camelize
        end

        ActiveRecord::Base.descendants.map(&:name) & models
      }.call
    end

    # @return [Array<String>] Model class names that we want to exclude, according to the config file.
    def excluded_model_class_names
      config.excluded_models
    end

    # @return [Array<String>] Model class names that we want to include, implying exclusion of any others, according to the config file.
    def included_model_class_names
      config.exclusively_included_models
    end

    # @return [Array<String] Model class names that we want included in the SDK.
    def model_class_names
      @model_class_names ||= ((included_model_class_names.any?) ? included_model_class_names : all_model_class_names) - excluded_model_class_names
    end

    def named_routes
      @named_routes ||= config.named_routes
    end

    # Path of the YAML config file used to persist settings for excluding classes between runs
    # of this generator.
    # @return [String] Absolute path to the config file.
    def config_file_path
      Rails.root.join('.ios_sdk_config.yml')
    end

    def association_exists?(model, association)
      singular_symbol = association.active_record.name.demodulize.underscore.to_sym
      plural_symbol = association.active_record.name.demodulize.pluralize.underscore.to_sym

      model.reflect_on_association(singular_symbol) || model.reflect_on_association(plural_symbol) ? true : false
    end

  end
end
