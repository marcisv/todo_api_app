require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { FactoryGirl.build(:task) }

  describe 'validation' do
    it 'is valid' do
      expect(task).to be_valid
    end

    context 'when title is not present' do
      before { task.title = '' }

      it 'has one error on title' do
        expect(task).not_to be_valid
        expect(task.errors[:title].count).to eq 1
      end
    end
  end

end
