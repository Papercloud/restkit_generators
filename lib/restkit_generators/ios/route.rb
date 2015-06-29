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
        @model_name ||= guess_name.to_s

        raise "Can't infer serializer name from model name from '#{@route.name}'" unless @model_name

        @model_name
      end

      def model
        @model ||= RestkitGenerators::Ios::Model.new(model_name, @config)
      end

      def ios_route_name
        if has_namespace?
          strip_namespace
        else
          @route.name
        end
      end

      def ios_prefixed_route(verb)
        "#{verb.downcase}_#{ios_route_name}"
      end

      def ios_constant_name(verb)
        "k#{ios_prefixed_route(verb).camelize}Route"
      end

      def http_verbs
        extract_verbs
      end

      def ios_route_verb
        @ios_route_verb ||= http_verbs.map{ |v| 'RKRequestMethod' << v }.join('|')
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

      def namespace
        @options[:strip_namespace]
      end

      def action
        @route.defaults[:action]
      end

      def is_member_action?
        @route.name.start_with?(action)
      end

      def namespace_start
        is_member_action? ? action.length + 1 : 0
      end

      def has_namespace?
        @route.name.slice(namespace_start, namespace.length).eql? namespace
      end

      def strip_namespace
        strip = namespace.end_with?('_') ? namespace : namespace + '_'
        route_name = @route.name

        if namespace_start > 0
          route_name.slice!(namespace_start, strip.length)
        else
          route_name = route_name[strip.length..-1]
        end

        route_name
      end

      def find_route(name)
        Rails.application.routes.routes.named_routes[name].tap do |route|
          raise "Could not find named route '#{name}'" unless route
        end
      end

      def extract_verbs
        routes = Rails.application.routes.routes.routes # The hell?
        route_names = routes.map(&:name)
        route_index = route_names.index(@route.name)
        route_group = routes[route_index..-1].take_while{|n| n.name == @route.name || n.name.nil? }

        route_group.map{ |r| r.verb.source.gsub(/[$^]/, '') }
      end

      def controller
        @controller ||= (@route.defaults[:controller] + '_controller').camelize.constantize
      end

      def guess_name
        namespaces = controller.name.gsub(/Controller$/, '').split('::')
        search_namespaces(namespaces)
      rescue NameError => e
        nil
      end

      def search_namespaces(namespaces = [])
        namespaces.join('::').classify.constantize.tap do |klass|
          raise NameError unless klass.descends_from_active_record?
        end
      rescue NameError => e
        if namespaces.length > 0
          search_namespaces namespaces[1..-1]
        else
          raise NameError
        end
      end
    end
  end
end
