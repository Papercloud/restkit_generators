class Railtie < ::Rails::Railtie
  generators do
    require File.join(RestkitGenerators::Engine.root, "lib/generators/rest_kit/ios_model_generator")
  end
end