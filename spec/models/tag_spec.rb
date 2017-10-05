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
  end

end
