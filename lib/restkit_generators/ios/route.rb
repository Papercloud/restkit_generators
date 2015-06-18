module RestkitGenerators
  module Ios
    class Route
      def initialize(route_name, options, config)
        @route    = find_route(route_name)
        @options  = options
        @config   = config
      end

      def model_name
        @model_name ||= @options[:model]
        @model_name ||= (@route.defaults[:controller] + '_controller').camelize.constantize.controller_name.classify

        raise "Can't infer serializer name from model name from '#{route.name}'" unless @model_name

        @model_name.singularize
      end

      def model
        @model ||= RestkitGenerators::Ios::Model.new(model_name, @config)
      end

      def ios_route_name
        strip = @options[:strip_namespace]
        if @route.name[0...strip.length] == strip
          strip = strip + "_" unless strip.include? "_"
          return @route.name[strip.length..@route.name.length]
        else
          @route.name
        end
      end

      def ios_route_verb
        @route.verb.source.gsub(/[$^]/, '')
      end

      def ios_route_path
        @route.path.spec.map(&:left).select{ |p| p.is_a? String }.join.gsub(':format', 'json')
      end

      def serializer
        if @options[:serializer] && @options[:serializer].camelize.include?("Serializer")
          @options[:serializer].constantize
        elsif @options[:serializer]
          (@options[:serializer] + "_serializer").camelize.constantize
        else
          (model_name + "_serializer").camelize.constantize
        end
      end

      # Associations specified in the serializer, which we assume are embedded as unique objects under their own root.
      def associations
        serializer_associations = serializer._associations.keys

        model.associations.select{ |a|
          serializer_associations.include?(a.name)
        }.map{ |a|
          RestkitGenerators::Ios::Association.new(a, @config)
        }
      end

      # Root for the main object requested. Plural for index actions, singular for show and others.
      def root_name
        if @route.defaults[:action] == "index"
          model.model_name.demodulize.downcase.pluralize
        else
          model.model_name.demodulize.downcase.singularize
        end
      end

      private

      def find_route(name)
        Rails.application.routes.routes.named_routes[name].tap do |route|
          raise "Could not find named route '#{name}'" unless route
        end
      end
    end
  end
end
