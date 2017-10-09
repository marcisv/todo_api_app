require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { FactoryGirl.build(:tag) }

  describe 'validation' do
    it 'is valid' do
      expect(tag).to be_valid
    end

    context 'when title is not present' do
      before { tag.title = '' }

      it 'has one error on title' do
        expect(tag).not_to be_valid
        expect(tag.errors[:title].count).to eq 1
      end
    end

    context 'when tag with the same title exists' do
      before { FactoryGirl.create(:tag, title: tag.title) }

      it 'has one error on title' do
        expect(tag).not_to be_valid
        expect(tag.errors[:title].count).to eq 1
      end

      context 'when trying to save the record with the same name to database' do
        it 'raises an error' do
          expect { tag.save(validate: false) }.to raise_error ActiveRecord::RecordNotUnique
        end
      end
    end
  end

  describe '.by_title' do
    let(:title) { 'Today' }
    let(:search_param) { title[1..3] }

    it 'returns an empty relation' do
      expect(Tag.by_title(search_param)).to be_empty
    end

    context 'when tag with title containing the param exists' do
      let!(:tag) { FactoryGirl.create(:tag, title: title) }

      it 'includes the tag in the result' do
        expect(Tag.by_title(search_param).include?(tag)).to eq true
      end
    end

    context 'when tag with completely different name exists' do
      let!(:tag) { FactoryGirl.create(:tag, title: 'Different') }

      it 'does not include the tag in the result' do
        expect(Tag.by_title(search_param).include?(tag)).to eq false
      end
    end
  end

end
