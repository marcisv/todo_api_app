require 'rails_helper'

RSpec.describe 'tasks#update', type: :request do

  let!(:task) { FactoryGirl.create(:task, title: 'Old task title') }
  let(:new_task_title) { 'New task title' }

  it 'updates the task name and returns the JSON data with status 200' do
    patch "/api/v1/tasks/#{task.id}", params: {data: {type: 'tasks', id: 2, attributes: {title: new_task_title}}}

    expect(response.status).to eq 200

    expect(response.body).to be_json_eql %{
      {"data":{
        "id":"#{task.id}",
        "type":"tasks",
        "attributes":{"title":"#{new_task_title}"}
      }}
    }
  end

  context 'when parameters are not valid' do
    let(:new_task_title) { '' }

    it 'returns errors with status 400' do
      patch "/api/v1/tasks/#{task.id}", params: {data: {type: 'tasks', id: 2, attributes: {title: new_task_title}}}

      expect(response.status).to eq 400
    end
  end

end
