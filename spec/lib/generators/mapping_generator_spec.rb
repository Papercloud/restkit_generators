require "spec_helper"

describe RestKit::MappingGenerator do

  destination File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy/Generated")
  arguments ["Post", "--ios-path=#{File.join(RestkitGenerators::Engine.root, 'spec/dummy-ios/Dummy/')}"] 

  before(:all) do
    prepare_destination
    run_generator
  end

  # after :all do
  #   dummy_project_root = File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy")
  #   Dir.chdir(dummy_project_root) {
  #     Bundler.with_clean_env {
  #       system 'pod install --no-repo-update'
  #       system "xctool -workspace Dummy.xcworkspace -scheme Dummy -sdk iphonesimulator"
  #     }
  #   }
  # end

  it "creates an interface file" do
    assert_file File.join(destination_root, "Mappings/_Post+Mapping.h")
  end

  it "creates an implementation file" do
    assert_file File.join(destination_root, "Mappings/_Post+Mapping.m")
  end

  # it "generates a connection for belongs_to relationship" do
  #   assert_file "tmp/restkit_generators/RKObjectMapping+CommentSerializerMapping.h", "postConnection"
  # end
  
end