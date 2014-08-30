module RestkitGenerators
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.assets false
      g.helper false
    end

    Rails::Generators.hide_namespace "rest_kit:ios_model"

  end
end
