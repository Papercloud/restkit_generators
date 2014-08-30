class RestKit::AllGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  # Generate a config file if we don't have one already, which persists preferences of classes
  # and attributes to exclude when re-running this generator.
  def generate_config_file
    unless File.exist? config_file_path
      template "ios_sdk_config.yml.erb", config_file_path
    else
      puts "Using existing config gile at #{config_file_path}"
    end
  end

  private

  # Path of the YAML config file used to persist settings for excluding classes between runs
  # of this generator.
  # @return [String] Absolute path to the config file.
  def config_file_path
    Rails.root.join('.ios_sdk_config.yml')
  end

  # @return [Array<String>] All model class names in the Rails project
  def all_model_class_names
    @all_model_class_names ||= ->{
      Dir[Rails.root.join("app/models/**/*.rb")].each {|file| require file }
      ActiveRecord::Base.descendants.map(&:name)
    }.call
  end

  # @return [Array<String>] Model class names that we want to exclude
  def excluded_class_names
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
      'exclude_models' => excluded_class_names
    }
  end

end