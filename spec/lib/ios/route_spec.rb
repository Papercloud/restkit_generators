require 'spec_helper'

module RestkitGenerators
  describe Ios::Route do
    let(:config) { RestkitGenerators::Config.new('config/default.yml') }
    let(:route_name) { 'api_posts' }

    subject do
      RestkitGenerators::Ios::Route.new('api_posts', { strip_namespace: 'api' }, config)
    end

    context 'no options' do
      it 'guesses the model name based off the controller' do
        expect(subject.model_name).to eq 'Post'
      end

      it 'returns an ios model object of the found model' do
        expect(subject.model.model_name).to eq 'Post'
      end

      it 'formats the ios route name' do
        expect(subject.ios_route_name).to eq 'posts'
      end

      it 'formats the ios route verb' do
        expect(subject.ios_route_verb).to eq 'GET'
      end

      it 'formats the ios route path' do
        expect(subject.ios_route_path).to eq '/api/posts.json'
      end

      it 'guesses the serializer class' do
        expect(subject.serializer).to eq PostSerializer
      end

      it 'returns a collection of ios associations based on the serializer' do
      end
    end

    describe '#root_name' do
      context 'index action' do
        subject do
          RestkitGenerators::Ios::Route.new('api_posts', { strip_namespace: 'api' }, config)
        end

        it 'returns the root keypath to be used for the mapped route action' do
          expect(subject.root_name).to eq 'posts'
        end
      end

      context 'non-index action' do
        subject do
          RestkitGenerators::Ios::Route.new('api_post', { strip_namespace: 'api' }, config)
        end

        it 'returns the root keypath to be used for the mapped route action' do
          expect(subject.root_name).to eq 'post'
        end
      end
    end

    context 'specified model' do
      subject do
        RestkitGenerators::Ios::Route.new('api_posts', { strip_namespace: 'api', model: 'Tag' }, config)
      end

      it 'returns the model name based off the specified model' do
        expect(subject.model_name).to eq 'Tag'
      end

      it 'returns the ios model object based off the specified model' do
        expect(subject.model.model_name).to eq 'Tag'
      end
    end

    context 'specified serializer' do
      subject do
        RestkitGenerators::Ios::Route.new('api_posts', { strip_namespace: 'api', serializer: 'TagSerializer' }, config)
      end

      it 'returns the serializer based off the specified serializer' do
        expect(subject.serializer).to eq TagSerializer
      end
    end
  end
end
