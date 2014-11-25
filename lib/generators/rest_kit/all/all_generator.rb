require_relative '../helpers'

class RestKit::AllGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  class_option :ios_path, type: :string, required: true
  class_option :data_model_path, type: :string, required: false, description: "Path to an existing /contents file with an xcdatamodel. Usually for your most recent model version."

  def run_other_generators

    # Generate model classes and Core Data entities.
    model_class_names.each do |name|
      args = ''
      args << name
      args << " --ios-path=#{options[:ios_path]}" if options[:ios_path]
      args << " --data-model-path=#{options[:data_model_path]}" if options[:data_model_path]
      args << " --skip-pod-install=true"
      args << " --exclude-columns=#{excluded_columns_for_model(name).join(',')}"
      puts "Invoking rest_kit:model " + args
      generate "rest_kit:model", args
    end

    pod_install
  end

  private

  # @return [Array<String>] Names of routes that we want included in the SDK.
  def route_names
    model_class_names.map do |model_name|
      model_name.underscore.pluralize
    end.select do |route_name|
      Rails.application.routes.routes.named_routes[route_name]
    end
  end

  # @param model_name [String] The model's name
  # @return [Array<String>] Columns to exclude for this model. Returns an empty array if none.
  def excluded_columns_for_model(model_name)
    config.excluded_columns_for_model(model_name)
  end

  include RestKit::Helpers

end