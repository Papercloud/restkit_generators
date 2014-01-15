module RestKit
  class RouteGenerator < IosModelGenerator
    source_root File.expand_path('../templates', __FILE__)
    
    class_option :strip_namespace, type: :string, default: 'api',\
     desc: "Strip this namespace from the route's name in iOS"

    class_option :serializer, type: :string, default: nil,\
     desc: "Name of the active_model_serializer from which infer RKResponseDescriptors"

    def generate_route
      empty_directory destination_path("")
      template "interface.h.erb",       destination_path("#{filename}.h")
      template "implementation.m.erb",  destination_path("#{filename}.m")
    end

    def generate_response_descriptors
      (associations + [root_name]).each do |association|
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

    private

    def destination_path(path)
      super(File.join("Routes", path))
    end

    def ios_route_name
      strip = options[:strip_namespace]
      if route.name[0...strip.length] == strip
        strip = strip + "_" unless strip.include? "_"
        return route.name[strip.length..route.name.length]
      else
        route.name
      end
    end

    def ios_route_verb
      route.verb.source.gsub(/[$^]/, '')
    end

    def ios_route_path
      route.optimized_path + ".json"
    end

    def category_name
      (ios_route_name + "_route").camelize
    end

    def filename
      "RKObjectManager+" + (ios_route_name + "_route").camelize
    end

    def route
      route = Rails.application.routes.routes.named_routes[name]
      raise "Could not find named route '#{name}'" unless route
      route
    end

    def serializer
      if options[:serializer] and options[:serializer].camelize.include? "Serializer"
        options[:serializer].constantize
      elsif options[:serializer]
        (options[:serializer] + "_serializer").camelize.constantize
      else
        (model_name + "_serializer").camelize.constantize
      end
    end

    def model_name
      model_name = route.name.split("_").last
      raise "Can't infer serializer name from model name from '#{route.name}'" unless model_name
      model_name.singularize
    end

    # Associations specified in the serializer, which we assume are embedded as unique objects under their own root.
    def associations
      serializer._associations.keys.map(&:to_s).map(&:pluralize)
    end

    # Root for the main object requested. Plural for index actions, singular for show and others.
    def root_name
      if route.defaults[:action] == "index"
        model_name.pluralize
      else
        model_name.singularize
      end
    end

  end
end