require 'spec_helper'

describe RestkitGenerators::Config do
  context 'default config file' do
    subject(:default_config) do
      RestkitGenerators::Config.new('config/default.yml')
    end

    it 'exclusively includes specifed models' do
      expect(default_config.exclusively_included_models).to include('User', 'Comment', 'Post', 'Tag')
    end

    it 'excludes specified models' do
      expect(default_config.excluded_models).to include('AdminUser', 'ActiveAdmin::Comment')
    end

    describe 'model configuration' do
      it 'allows model-specifc config to be specified' do
        expect(default_config.models.keys).to eq(['user'])
      end

      describe 'field exclusion' do
        it 'returns an array of the specified excluded fields' do
          expect(default_config.excluded_columns_for_model('User')).to eq(['encrypted_password', 'reset_password_token'])
        end

        it 'returns an empty array if the specified model isnt configured' do
          expect(default_config.excluded_columns_for_model('Monster')).to eq([])
        end
      end

      describe 'field addition' do
        it 'returns an array of the additional field structs' do
          field_struct = OpenStruct.new(name: 'average_rating', type: 'float')
          expect(default_config.additional_columns_for_model('User')).to include(field_struct)
        end

        it 'returns an empty array if the specified model isnt configured' do
          expect(default_config.additional_columns_for_model('Monster')).to eq([])
        end
      end

      describe 'field non-persistence' do
        it 'returns an array of the specified fields to be not be persisted by core data' do
          expect(default_config.non_persisted_columns_for_model('User')).to include('authentication_token')
        end

        it 'returns an empty array if the specified model isnt configured' do
          expect(default_config.non_persisted_columns_for_model('Monster')).to eq([])
        end
      end
    end

    describe 'route configuration' do
      it 'allows a namespace to be specified that will be stripped' do
        expect(default_config.route_config[:strip_namespace]).to eq 'api'
      end

      it 'allows a list of named routes to be specified that will be generated via the route generator' do
        expect(default_config.named_routes).to include 'api_posts'
      end
    end
  end

  context 'missing file' do
    let(:missing_config) { RestkitGenerators::Config.new('config/missing.yml') }

    it 'returns an empty hash of options' do
      expect { missing_config }.to output("No .ios_sdk_config.yml file found!\n").to_stdout
    end
  end
end