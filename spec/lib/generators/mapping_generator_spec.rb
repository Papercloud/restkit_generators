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

  context 'interface file' do
    let(:file) { File.join(destination_root, 'Mappings/_Post+Mapping.h') }

    it 'creates an interface file' do
      expect(File).to exist(file)
    end

    it 'specifies the correct class interface' do
      expect(File.read(file)).to include '@interface _Post'
    end

    it 'specifies the correct category' do
      expect(File.read(file)).to include '@interface _Post (Mapping)'
    end
  end

  context 'implementation file' do
    let(:file) { File.join(destination_root, 'Mappings/_Post+Mapping.m') }

    it 'creates an implementation file' do
      expect(File).to exist(file)
    end

    it 'imports the header file' do
      expect(File.read(file)).to include '#import "_Post+Mapping.h"'
    end

    it 'imports the mapping files belong to included associations' do
    end

    it 'specifies the correct class implementation' do
      expect(File.read(file)).to include '@implementation _Post'
    end

    it 'specifies the correct category' do
      expect(File.read(file)).to include '@implementation _Post (Mapping)'
    end
  end
end