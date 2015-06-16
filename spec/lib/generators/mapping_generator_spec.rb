require "spec_helper"

describe RestKit::MappingGenerator do

  destination File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy/Generated")
  arguments ["Post", "--ios-path=#{File.join(RestkitGenerators::Engine.root, 'spec/dummy-ios/Dummy/')}"]

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a protocol header file' do
    expect(File).to exist(File.join(destination_root, 'Mappings/MappingProtocol.h'))
  end

  it 'creates an interface file' do
    expect(File).to exist(File.join(destination_root, 'Mappings/_Post+Mapping.h'))
  end

  it 'creates an implementation file' do
    expect(File).to exist(File.join(destination_root, 'Mappings/_Post+Mapping.m'))
  end

end