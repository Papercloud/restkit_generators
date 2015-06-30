require_relative '../helpers'

class RestKit::AllGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  class_option :ios_path, type: :string, required: true
  class_option :data_model_path, type: :string, required: false, description: "Path to an existing /contents file with an xcdatamodel. Usually for your most recent model version."
  class_option :skip_pod_install, type: :boolean, required: false, default: false

  def run_other_generators

    # Generate model classes and Core Data entities.
    RestkitGenerators.model_class_names.each do |name|
      model = RestkitGenerators::Ios::Model.new(name)

      args = ''
      args << name
      args << " --ios-path=#{options[:ios_path]}" if options[:ios_path]
      args << " --data-model-path=#{options[:data_model_path]}" if options[:data_model_path]
      args << " --skip-pod-install=true"
      args << " --exclude-columns=#{model.excluded_columns.join(',')}"
      puts "Invoking rest_kit:model " + args
      generate "rest_kit:model", args

      puts "Invoking rest_kit:mapping " + args
      generate "rest_kit:mapping", args

      puts "Invoking rest_kit:validator " + args
      generate "rest_kit:validator", args
    end

    RestkitGenerators.named_routes.each do |name|
      route_config = RestkitGenerators.config.route_config

      args = ''
      args << name
      args << " --ios-path=#{options[:ios_path]}" if options[:ios_path]
      args << " --skip-pod-install=true"
      args << " --strip-namespace=#{route_config[:strip_namespace]}" if route_config[:strip_namespace]

      puts "Invoking rest_kit:route " + args
      generate "rest_kit:route", args
    end

    pod_install unless options[:skip_pod_install]
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

  include RestKit::Helpers
end