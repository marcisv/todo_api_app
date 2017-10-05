require 'rails_helper'

RSpec.describe 'tasks#destroy', type: :request do

  let!(:task) { FactoryGirl.create(:task, title: 'Old task title') }

  it 'destroys the task' do
    delete "/api/v1/tasks/#{task.id}"

    expect(response.status).to eq 204
    expect(response.body).to be_empty
    expect(Task.find_by(id: task.id)).not_to be_present
  end

end
