class Railtie < ::Rails::Railtie
  generators do
    require File.join(RestkitGenerators::Engine.root, "lib/generators/restkit_generators/ios_generator")
  end
end