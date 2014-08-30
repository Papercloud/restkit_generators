require_relative '../helpers'

class RestKit::AllGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  class_option :ios_path, type: :string, required: true
  class_option :data_model_path, type: :string, required: false, description: "Path to an existing /contents file with an xcdatamodel. Usually for your most recent model version."

  # Generate a config file if we don't have one already, which persists preferences of classes
  # and attributes to exclude when re-running this generator.
  def generate_config_file
    unless File.exist? config_file_path
      template "ios_sdk_config.yml.erb", config_file_path
    else
      puts "Using existing config gile at #{config_file_path}"
    end
  end

  def run_other_generators

    # Generate model classes and Core Data entities.
    model_class_names.each do |name|
      args = name
      args << " --ios-path=#{options[:ios_path]}" if options[:ios_path]
      args << " --data-model-path=#{options[:data_model_path]}" if options[:data_model_path]
      args << " --skip-pod-install=true"
      generate "rest_kit:model", args
    end

    pod_install
  end

  private

  # @return [Array<String>] All model class names in the Rails project
  def all_model_class_names
    @all_model_class_names ||= ->{
      Dir[Rails.root.join("app/models/**/*.rb")].each {|file| require file }
      ActiveRecord::Base.descendants.map(&:name)
    }.call
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

  # @return [Array<String>] Model class names that we want to exclude, according to the config file.
  def excluded_model_class_names
    config[:exclude_models]
  end

  # @return [Array<String] Model class names that we want included in the SDK.
  def model_class_names
    all_model_class_names - excluded_model_class_names
  end

  # @return [Array<String>] Names of routes that we want included in the SDK.
  def route_names
    model_class_names.map do |model_name|
      model_name.underscore.pluralize
    end.select do |route_name|
      Rails.application.routes.routes.named_routes[route_name]
    end
  end

  # @return [Hash] Config to be written to our config file as YAML.
  def default_config_hash
    {
      'exclude_models' => default_excluded_model_class_names
    }
  end

  # Path of the YAML config file used to persist settings for excluding classes between runs
  # of this generator.
  # @return [String] Absolute path to the config file.
  def config_file_path
    Rails.root.join('.ios_sdk_config.yml')
  end

  # @return [Hash] Config loaded from YAML config file.
  def config
    @config ||= YAML.load(File.open(config_file_path)).with_indifferent_access
  end

  include RestKit::Helpers

end