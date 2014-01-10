require "spec_helper"

describe RestkitGenerators::ModelGenerator do

  destination File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy/Generated")
  arguments %w( Post )

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates an interface file" do
    assert_file File.join(destination_root, "gen/_Post.h")
  end

  it "creates an implementation file" do
    assert_file File.join(destination_root, "gen/_Post.m")
  end
  
end