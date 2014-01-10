require "spec_helper"

describe RestkitGenerators::MappingGenerator do

  destination File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy/Generated")
  arguments %w( Post )  

  before(:all) do
    prepare_destination
    run_generator
  end

  after :all do
    dummy_project_root = File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy")
    Dir.chdir(dummy_project_root) {
      Bundler.with_clean_env {
        system 'pod install --no-repo-update'
        system "xctool -workspace Dummy.xcworkspace -scheme Dummy -sdk iphonesimulator"
      }
    }
  end

  it "creates an interface file" do
    assert_file File.join(destination_root, "gen/RKObjectMapping+PostSerializerMapping.h")
  end

  # it "generates a connection for belongs_to relationship" do
  #   assert_file "tmp/restkit_generators/RKObjectMapping+CommentSerializerMapping.h", "postConnection"
  # end
  
end