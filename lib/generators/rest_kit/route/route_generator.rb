module RestKit
  class RouteGenerator < IosModelGenerator
    include RestKit::Helpers

    source_root File.expand_path('../templates', __FILE__)

    class_option :strip_namespace, type: :string, default: 'api',\
     desc: "Strip this namespace from the route's name in iOS"

    class_option :serializer, type: :string, default: nil,\
     desc: "Name of the active_model_serializer from which infer RKResponseDescriptors"

    class_option :model, type: :string, default: nil,\
     desc: "Name of the model"

    def generate_route
      empty_directory destination_path("")
      template "interface.h.erb",       destination_path("#{filename}.h")
      template "implementation.m.erb",  destination_path("#{filename}.m")
    end

    def generate_response_descriptors
      route.associations.each do |association|
        inject_into_file destination_path("#{filename}.m"), after: "{\n" do |config|
          embed_template("response_descriptor.m.erb", "  ", binding())
        end
      end
    end

    def add_to_shared_header
      template "setup_interface.h.erb", destination_path("RKObjectManager+Routes.h"), skip: true
      template "setup_interface.m.erb", destination_path("RKObjectManager+Routes.m"), skip: true

      inject_into_file destination_path("RKObjectManager+Routes.h"), after: "#import \"Generated.h\"\n" do |config|
        "#import \"#{filename}.h\"\n"
      end

      inject_into_file destination_path("RKObjectManager+Routes.m"), after: "{\n" do |config|
        "  [self setup#{category_name}WithObjectManager:[RKObjectManager sharedManager]];\n"
      end
    end

    def update_project
      pod_install unless options[:skip_pod_install]
    end

    private

    def route
      @route ||= RestkitGenerators::Ios::Route.new(name, options, config)
    end

    def destination_path(path)
      super(File.join("Routes", path))
    end

    def category_name
      @category_name ||= (route.ios_route_name + "_route").camelize
    end

    def filename
      "RKObjectManager+" << category_name
    end
  end
end