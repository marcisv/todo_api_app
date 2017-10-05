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

  describe 'updating tags' do
    let(:current_task_tag_titles) { [] }
    let(:tag_title_1) { 'Today' }
    let(:tag_title_2) { 'Someday' }
    let(:new_task_tag_titles) { [tag_title_1, tag_title_2] }

    subject :task do
      current_task_tags = current_task_tag_titles.map do |title|
        FactoryGirl.build(:task_tag, task: nil, tag: FactoryGirl.create(:tag, title: title))
      end
      FactoryGirl.create(:task, task_tags: current_task_tags)
    end

    it 'creates the task tags' do
      task.update_attributes(tags: new_task_tag_titles)
      expect(Tag.count).to eq 2
      expect(task.tags.map(&:title)).to eq new_task_tag_titles
    end

    context 'when a tag with one of titles already exists in the database' do
      before do
        FactoryGirl.create(:tag, title: tag_title_1)
        task.update_attributes(tags: new_task_tag_titles)
      end

      it 'creates the task tags' do
        expect(task.tags.map(&:title)).to eq new_task_tag_titles
      end

      it 'does not create duplicate tag record for the existing tag title' do
        expect(Tag.count).to eq 2
        expect(Tag.where(title: tag_title_1).count).to eq 1
      end
    end

    context 'when task has other attribute that is not valid' do
      before do
        task.update_attributes(tags: new_task_tag_titles, title: '')
      end

      it 'assigns the new task tags' do
        expect(task.task_tags.map(&:title)).to eq new_task_tag_titles
      end

      it 'does not store the tags to database' do
        expect(task.tags.map(&:title)).to be_empty
        expect(Tag.count).to eq 0
      end
    end

    context 'when tags already exist' do
      let(:current_task_tag_titles) { [tag_title_1, tag_title_2] }

      context 'when updating with mix of new and existing tag titles' do
        let(:new_task_tag_titles) { [tag_title_1, 'Urgent'] }

        it 'updates the tags to the only new ones' do
          task.update_attributes(tags: new_task_tag_titles)
          expect(task.tags.map(&:title)).to eq new_task_tag_titles
        end
      end

      context 'when the tags set to an empty array' do
        it 'unsets the tags' do
          task.update_attributes(tags: [])
          expect(task.tags).to be_empty
        end

        context 'when task has other attribute that is not valid' do
          before { task.update_attributes(tags: [], title: '') }

          it 'marks the the task tags for destruction' do
            expect(task.task_tags).to be_present
            task.task_tags.each { |tt| expect(tt).to be_marked_for_destruction }
          end

          it 'does not remove the task tags from the database' do
            expect(task.tags.pluck(:title)).to eq current_task_tag_titles
          end
        end
      end
    end

  end

end
