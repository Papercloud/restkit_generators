require 'spec_helper'

module RestkitGenerators
  describe Ios::Model do
    let(:config) { RestkitGenerators::Config.new('config/default.yml') }

    context 'has_many association' do
      let(:model)  { RestkitGenerators::Ios::Model.new('user', config) }
      let(:association) { model.associations.find{ |a| a.macro == :has_many } }
      subject do
        RestkitGenerators::Ios::Association.new(association, config)
      end

      it 'returns a model representation of the associated model' do
        expect(subject.model.model_name).to eq('Post')
      end

      it 'returns the correct deletion rule for ios' do
        expect(subject.ios_deletion_rule).to eq 'Cascade'
      end

      it 'returns the ios set association' do
        expect(subject.ios_association_type).to eq 'NSOrderedSet *'
      end

      it 'guesses the inverse association if none is specified' do
        post_model = RestkitGenerators::Ios::Model.new('post', config)
        user_association = post_model.associations.find{ |a| a.name == :user }

        expect(subject.inverse_of).to eq user_association
      end

      it 'doesnt need to guess if the inverse is explicitly set' do
        post_model = RestkitGenerators::Ios::Model.new('post', config)
        user_association = post_model.associations.find{ |a| a.name == :user }
        allow(association).to receive(:options) { { inverse_of: :user } }

        expect(subject).not_to receive(:guess_inverse)
        expect(subject.inverse_of).to eq user_association
      end
    end

    context 'belongs_to association' do
      let(:model)  { RestkitGenerators::Ios::Model.new('post', config) }
      let(:association) { model.associations.find{ |a| a.macro == :belongs_to } }
      subject do
        RestkitGenerators::Ios::Association.new(association, config)
      end

      it 'returns a model representation of the associated model' do
        expect(subject.model.model_name).to eq('User')
      end

      it 'returns the correct deletion rule for ios' do
        expect(subject.ios_deletion_rule).to eq 'Cascade'
      end

      it 'returns the ios set association' do
        expect(subject.ios_association_type).to eq 'User *'
      end

      it 'guesses the inverse association if none is specified' do
        user_model = RestkitGenerators::Ios::Model.new('user', config)
        post_association = user_model.associations.find{ |a| a.name == :posts }

        expect(subject.inverse_of).to eq post_association
      end
    end

    context 'has_and_belongs_to_many association' do
      let(:model)  { RestkitGenerators::Ios::Model.new('post', config) }
      let(:association) { model.associations.find{ |a| a.macro == :has_and_belongs_to_many } }
      subject do
        RestkitGenerators::Ios::Association.new(association, config)
      end

      it 'returns a model representation of the associated model' do
        expect(subject.model.model_name).to eq('Tag')
      end

      it 'returns the correct deletion rule for ios' do
        expect(subject.ios_deletion_rule).to eq 'Nullify'
      end

      it 'returns the ios set association' do
        expect(subject.ios_association_type).to eq 'NSOrderedSet *'
      end

      it 'guesses the inverse association if none is specified' do
        tag_model = RestkitGenerators::Ios::Model.new('tag', config)
        post_association = tag_model.associations.find{ |a| a.name == :posts }

        expect(subject.inverse_of).to eq post_association
      end
    end

    context 'has_one association' do
    end

    context 'polymorphic association' do
      let(:model)  { RestkitGenerators::Ios::Model.new('comment', config) }
      let(:association) { model.associations.find{ |a| a.macro == :belongs_to } }
      subject do
        RestkitGenerators::Ios::Association.new(association, config)
      end

      it 'knows that its polymorphic' do
        expect(subject.is_polymorphic?).to eq true
      end

      it 'can be unpolymorphised' do
        unpolymorphised = subject.unpolymorphise(['User', 'Post', 'Tag', 'Comment'])

        expect(unpolymorphised.length).to eq 1
        expect(unpolymorphised.first.klass).to eq Post
        expect(unpolymorphised.first.active_record).to eq association.active_record
        expect(unpolymorphised.first.name).to eq :post
        expect(unpolymorphised.first.macro).to eq :belongs_to
      end
    end
  end
end
