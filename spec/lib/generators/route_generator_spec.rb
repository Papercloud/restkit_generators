require "spec_helper"

describe RestKit::RouteGenerator do

  destination File.join(RestkitGenerators::Engine.root, "spec/dummy-ios/Dummy/Generated")
  arguments ["api_posts", "--ios-path=#{File.join(RestkitGenerators::Engine.root, 'spec/dummy-ios/Dummy/')}"]

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a setup interface file' do
    expect(File).to exist(File.join(destination_root, 'Routes/RKObjectManager+Routes.h'))
  end

  it 'creates a setup implementation file' do
    expect(File).to exist(File.join(destination_root, 'Routes/RKObjectManager+Routes.m'))
  end

  context 'interface file' do
    let(:file) { File.join(destination_root, 'Routes/RKObjectManager+PostsRoute.h') }

    subject do
      File.read(file)
    end

    it 'creates an interface file' do
      expect(File).to exist(file)
    end

    it 'specifies the correct class interface' do
      expect(subject).to include '@interface RKObjectManager (PostsRoute)'
    end
  end

  context 'implementation file' do
    let(:file) { File.join(destination_root, 'Routes/RKObjectManager+PostsRoute.m') }

    subject do
      File.read(file)
    end

    it 'creates an implementation file' do
      expect(File).to exist(file)
    end

    it 'imports the header file' do
      expect(subject).to include '#import "RKObjectManager+PostsRoute.h"'
    end

    it 'specifies the correct class implementation' do
      expect(subject).to include '@implementation RKObjectManager (PostsRoute)'
    end

    it 'includes response descriptors for the tags keypath' do
      expect(subject).to include 'keyPath:@"tags"'
    end

    it 'includes response descriptors for the users keypath' do
      expect(subject).to include 'keyPath:@"users"'
    end

    it 'includes response descriptors for the comments keypath' do
      expect(subject).to include 'keyPath:@"comments"'
    end

    it 'includes response descriptors for the posts keypath' do
      expect(subject).to include 'keyPath:@"posts"'
    end

    it 'specifies the correct http verbs' do
      expect(subject).to include 'method:RKRequestMethodGET|RKRequestMethodPOST'
    end
  end
end