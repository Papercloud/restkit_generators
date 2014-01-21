require "xcodeproj"

module RestKit
  class ScreenGenerator < Rails::Generators::NamedBase
    class_option :ios_path, type: :string, required: true

    def create_directories
      empty_directory destination_path
      empty_directory destination_path(screen_name)
      empty_directory destination_path(File.join(screen_name, "Controllers"))
      empty_directory destination_path(File.join(screen_name, "Views"))
      empty_directory destination_path(File.join(screen_name, "XIBs"))
    end

    def add_to_project
      project =Xcodeproj::Project.open(project_path)
      screen_group = project["#{project_name}/Screens"].new_group(screen_name, screen_name)
      screen_group.new_group("Controllers", "Controllers")
      screen_group.new_group("Views", "Views")
      screen_group.new_group("XIBs", "XIBs")
      project.save
    end

    protected

    def screen_name
      name.titleize
    end

    def project_path
      Dir[File.join(File.expand_path(options[:ios_path]), "*.xcodeproj")].first
    end

    def project_name
      File.basename(project_path, ".xcodeproj")
    end

    def destination_path(filename='')
      File.join(File.expand_path(options[:ios_path]), project_name, "Screens", filename)
    end


  end
end