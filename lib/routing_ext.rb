module RoutingExt

  module RouteSetExtensions
    def self.included(base)
      base.alias_method_chain :extract_request_environment, :host
    end

    def extract_request_environment_with_host(request)
      env = extract_request_environment_without_host(request)
      env.merge :host => request.host
    end
  end

  module RouteExtensions
    def self.included(base)
      base.alias_method_chain :recognition_conditions, :host
    end

    def recognition_conditions_with_host
      result = recognition_conditions_without_host
      result << "conditions[:host] === env[:host]" if conditions[:host]
      result << "ResourceLink.radio_host?(env[:host])" if conditions[:radio_host]
      result << "ResourceLink.show_host?(env[:host])" if conditions[:show_host]
      result
    end
  end

end

ActionController::Routing::RouteSet.send :include, RoutingExt::RouteSetExtensions
ActionController::Routing::Route.send :include, RoutingExt::RouteExtensions
