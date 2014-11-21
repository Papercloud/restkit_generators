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
      @config ||= Config.new()
    end

    # @return [Array<String>] Model class names that we want to exclude by default. Used to seed the config file.
    def default_excluded_model_class_names
      default_exclusion_regexes = [
        /AdminUser$/,
        /ActiveAdmin/
      ]

      all_model_class_names.select{ |name|
        default_exclusion_regexes.any? { |pattern| pattern =~ name }
      }
    end

    # @return [Hash] Config to be written to our config file as YAML.
    def default_config_hash
      {
        'exclude_models' => default_excluded_model_class_names
      }
    end

    # @return [Array<String>] All model class names in the Rails project
    def all_model_class_names
      @all_model_class_names ||= ->{
        Dir[Rails.root.join("app/models/**/*.rb")].each {|file| require file }
        ActiveRecord::Base.descendants.map(&:name)
      }.call
    end

  end
end