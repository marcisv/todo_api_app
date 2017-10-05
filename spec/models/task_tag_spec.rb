require 'rails_helper'

RSpec.describe TaskTag, type: :model do
  subject(:task_tag) { FactoryGirl.build(:task_tag) }

  describe 'validation' do
    it 'is valid' do
      expect(task_tag).to be_valid
    end

    context 'when task is not present' do
      before { task_tag.task = nil }

      it 'has one error on task' do
        expect(task_tag).not_to be_valid
        expect(task_tag.errors[:task].count).to eq 1
      end
    end

    context 'when tag is not present' do
      before { task_tag.tag = nil }

      it 'has one error on tag' do
        expect(task_tag).not_to be_valid
        expect(task_tag.errors[:tag].count).to eq 1
      end
    end
  end
end
