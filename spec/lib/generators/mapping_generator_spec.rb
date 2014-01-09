require "spec_helper"

describe RestkitGenerators::MappingGenerator do

  destination File.join(RestkitGenerators::Engine.root, 'tmp')
  arguments %w( Post )

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates an interface file" do
    assert_file "tmp/restkit_generators/RKManagedObject+PostSerializerMapping.h"
  end
  
end