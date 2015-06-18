require 'spec_helper'

module RestkitGenerators
  describe Ios::Model do
    let(:config) { RestkitGenerators::Config.new('config/default.yml') }

    subject do
      RestkitGenerators::Ios::Model.new('post', config)
    end

    it 'controls the id name for the model' do
      expect(subject.id_name).to eq 'primaryKey'
    end

    it 'collects all the model associatons' do
      expect(subject.associations.length).to eq 3
      expect(subject.associations.map(&:name)).to eq [:comments, :user, :tags]
    end

    it 'returns the models columns' do
      expect(subject.columns.map(&:name)).to eq ['id', 'name', 'date', 'views', 'user_id', 'created_at', 'updated_at']
    end

    it 'returns the models columns minus specified exclusions' do
      expect(subject.columns(['name']).map(&:name)).to eq ['id', 'date', 'views', 'user_id', 'created_at', 'updated_at']
    end

    it 'returns the models columns minus config exclusions' do
      allow(subject).to receive(:excluded_columns) { ['id', 'date', 'name'] }
      expect(subject.columns.map(&:name)).to eq ['views', 'user_id', 'created_at', 'updated_at']
    end

    it 'overrides config exclusions with specified exclusions' do
      allow(subject).to receive(:excluded_columns) { ['id', 'date', 'name'] }
      expect(subject.columns(['date', 'name']).map(&:name)).to include 'id'
    end

    it 'returns the models validators' do
      expect(subject.validators.length).to eq 1
    end

    it 'returns the models presence validator' do
      expect(subject.presence_validators).to eq ['name']
    end

    context 'single word model' do
      subject do
        RestkitGenerators::Ios::Model.new('user', config)
      end

      it 'camelizes the model name on init' do
        expect(subject.model_name).to eq 'User'
      end

      it 'formats the model name into the ios class name' do
        expect(subject.ios_class_name).to eq 'User'
      end

      it 'formats the model name into the ios base class name' do
        expect(subject.ios_base_class_name).to eq '_User'
      end

      it 'returns the model constant' do
        expect(subject.model).to eq User
      end
    end

    context 'multi word model' do
      subject do
        RestkitGenerators::Ios::Model.new('customer_account', config)
      end

      it 'camelizes the model name on init' do
        expect(subject.model_name).to eq 'CustomerAccount'
      end

      it 'formats the model name into the ios class name' do
        expect(subject.ios_class_name).to eq 'CustomerAccount'
      end

      it 'formats the model name into the ios base class name' do
        expect(subject.ios_base_class_name).to eq '_CustomerAccount'
      end

      it 'returns the model constant' do
        expect(subject.model).to eq CustomerAccount
      end
    end

    context 'namespaced model' do
      subject do
        RestkitGenerators::Ios::Model.new('chat/message', config)
      end

      it 'camelizes the model name on init' do
        expect(subject.model_name).to eq 'Chat::Message'
      end

      it 'formats the model name into the ios class name' do
        expect(subject.ios_class_name).to eq 'ChatMessage'
      end

      it 'formats the model name into the ios base class name' do
        expect(subject.ios_base_class_name).to eq '_ChatMessage'
      end

      it 'returns the model constant' do
        expect(subject.model).to eq Chat::Message
      end
    end

    context 'subclass model' do
      subject do
        RestkitGenerators::Ios::Model.new('user', config)
      end

      it 'returns the models base class' do
        expect(subject.parent_class).to eq ''
      end
    end
  end
end
