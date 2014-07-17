require "spec_helper"

describe RestKit::ModelGenerator do

  destination File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy/Generated")
  arguments ["Post", "--ios-path=#{File.join(RestkitGenerators::Engine.root, 'spec/dummy-ios/Dummy/')}"]

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates an interface file" do
    assert_file File.join(destination_root, "Models/_Post.h")
  end

  it "creates an implementation file" do
    assert_file File.join(destination_root, "Models/_Post.m")
  end
  
end