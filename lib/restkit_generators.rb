require 'rails/generators'

require 'restkit_generators/engine'
require 'restkit_generators/railtie'
require 'restkit_generators/config'

require 'restkit_generators/ios/model'
require 'restkit_generators/ios/association'
require 'restkit_generators/ios/route'

module RestkitGenerators
  def self.config
    @config ||= RestkitGenerators::Config.new(config_file_path)
  end

  # @return [Array<String>] Model class names that we want to exclude, according to the config file.
  def self.excluded_model_class_names
    config.excluded_models
  end

  # @return [Array<String>] Model class names that we want to include, implying exclusion of any others, according to the config file.
  def self.included_model_class_names
    config.exclusively_included_models
  end

  # @return [Array<String] Model class names that we want included in the SDK.
  def self.model_class_names
    @model_class_names ||= ((included_model_class_names.any?) ? included_model_class_names : all_model_class_names) - excluded_model_class_names
  end

  # @return [Array<String] Named routes that we want included in the SDK.
  def self.named_routes
    @named_routes ||= config.named_routes
  end

  private

  # Path of the YAML config file used to persist settings for excluding classes between runs
  # of this generator.
  # @return [String] Absolute path to the config file.
  def self.config_file_path
    Rails.root.join('.ios_sdk_config.yml')
  end

  # @return [Array<String>] All model class names in the Rails project
  def self.all_model_class_names
    @all_model_class_names ||= -> {
      Rails.application.eager_load!

      models = Dir["#{Rails.root}/app/models/**/*.rb"].map do |m|
        mp = m.reverse.chomp("#{Rails.root}/app/models/".reverse).reverse
        mp.chomp('.rb').camelize
      end

      ActiveRecord::Base.descendants.map(&:name) & models
    }.call
  end
end
