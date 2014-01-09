require "spec_helper"

describe RestkitGenerators::MappingGenerator do

  destination File.expand_path(MyEngine::Engine.root + "/tmp", __FILE__)
  arguments %w( Post )

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates an interface file" do
    assert_file "tmp/restkit_generators/RKManagedObject+PostSerializerMapping.h"
  end
  
end