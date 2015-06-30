require 'spec_helper'

module RestkitGenerators
  describe Ios::Model do
    before do
      allow(RestkitGenerators).to receive(:config_file_path) { 'config/default.yml' }
    end

    context 'has_many association' do
      let(:association) { User.reflect_on_all_associations.find{ |a| a.macro == :has_many } }

      subject do
        RestkitGenerators::Ios::Association.new(association)
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
        user_association = Post.reflect_on_all_associations.find{ |a| a.name == :user }

        expect(subject.inverse_of).to eq user_association
      end

      it 'doesnt need to guess if the inverse is explicitly set' do
        user_association = Post.reflect_on_all_associations.find{ |a| a.name == :user }
        allow(association).to receive(:options) { { inverse_of: :user } }

        expect(subject).not_to receive(:guess_inverse)
        expect(subject.inverse_of).to eq user_association
      end
    end

    context 'belongs_to association' do
      let(:association) { Post.reflect_on_all_associations.find{ |a| a.macro == :belongs_to } }

      subject do
        RestkitGenerators::Ios::Association.new(association)
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
        post_association = User.reflect_on_all_associations.find{ |a| a.name == :posts }

        expect(subject.inverse_of).to eq post_association
      end
    end

    context 'has_and_belongs_to_many association' do
      let(:association) { Post.reflect_on_all_associations.find{ |a| a.macro == :has_and_belongs_to_many } }

      subject do
        RestkitGenerators::Ios::Association.new(association)
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
        post_association = Tag.reflect_on_all_associations.find{ |a| a.name == :posts }

        expect(subject.inverse_of).to eq post_association
      end
    end

    context 'has_one association' do
    end

    context 'polymorphic association' do
      let(:association) { Comment.reflect_on_all_associations.find{ |a| a.macro == :belongs_to } }

      subject do
        RestkitGenerators::Ios::Association.new(association)
      end

      it 'knows that its polymorphic' do
        expect(subject.is_polymorphic?).to eq true
      end

      it 'can be unpolymorphised' do
        unpolymorphised = subject.unpolymorphise(['User', 'Post', 'Tag', 'Comment'])

        expect(unpolymorphised.length).to eq 1
        expect(unpolymorphised.first.klass).to eq Post
        expect(unpolymorphised.first.name).to eq :post
      end
    end
  end
end
