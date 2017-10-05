require 'rails_helper'

RSpec.describe 'tasks#create', type: :request do

  let(:task_title) { 'Wash laundry' }

  it 'persists the task and returns the JSON data with status 201' do
    post '/api/v1/tasks', params: {data: {attributes: {title: task_title}}}

    expect(response.status).to eq 201
    expect(response.body).to have_json_type(String).at_path('data/id')

    task = Task.find_by(id: parse_json(response.body, 'data/id'))

    expect(task).to be_present
    expect(task.title).to eq task_title

    expect(response.body).to be_json_eql %{
      {"data":{
        "id":"#{task.id}",
        "type":"tasks",
        "attributes":{"title":"#{task.title}"},
        "relationships": {"tags": {"data": []}}
      }}
    }
  end

  context 'when creating a task with tags' do
    let(:tag_titles) { %w(Today Tomorrow) }

    it 'persists the task with tags and returns the JSON data with status 201' do
      post '/api/v1/tasks', params: {data: {attributes: {title: task_title, tags: tag_titles}}}

      expect(response.status).to eq 201
      expect(response.body).to have_json_type(String).at_path('data/id')

      task = Task.find_by(id: parse_json(response.body, 'data/id'))

      expect(task).to be_present
      expect(task.tags.pluck(:title)).to eq tag_titles

      tags_json = task.tags.map { |t| %{\{"id":"#{t.id}","type":"tags"\}} }.join(',')
      expect(response.body).to be_json_eql %{
        {"data":{
          "id":"#{task.id}",
          "type":"tasks",
          "attributes":{"title":"#{task_title}"},
          "relationships": {"tags":{"data":[#{tags_json}]}}
        }}
      }
    end
  end

  context 'when parameters are not valid' do
    let(:task_title) { '' }

    it 'returns errors with status 400' do
      post '/api/v1/tasks', params: {data: {attributes: {title: task_title}}}

      expect(response.status).to eq 400
    end
  end

end
