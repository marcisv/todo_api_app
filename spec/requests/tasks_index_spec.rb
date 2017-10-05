require 'rails_helper'

RSpec.describe 'tasks#index', type: :request do

  it 'returns data with empty array' do
    get '/api/v1/tasks'

    expect(response.body).to be_json_eql %{{"data":[]}}
  end

  context 'when some tasks exist' do
    let!(:task_1) { FactoryGirl.create(:task) }
    let!(:task_2) { FactoryGirl.create(:task) }

    it 'returns data with the tasks' do
      get '/api/v1/tasks'

      expect(response.body).to be_json_eql %{
        {"data":[
          {
            "type":"tasks",
            "id":"#{task_1.id}",
            "attributes":{"title":"#{task_1.title}"},
            "relationships": {"tags": {"data": []}}
          }, {
            "type":"tasks",
            "id":"#{task_2.id}",
            "attributes":{"title":"#{task_2.title}"},
            "relationships": {"tags": {"data": []}}
          }
        ]}
      }
    end

    context 'when tags exist for one of the tasks' do
      let!(:task_2) { FactoryGirl.create(:task, tags: [tag_1, tag_2]) }
      let(:tag_1) { FactoryGirl.create(:tag) }
      let(:tag_2) { FactoryGirl.create(:tag) }

      it 'returns the data with the tags included' do
        get '/api/v1/tasks'

        expect(response.body).to be_json_eql %{
          {"data":[
            {
              "type":"tasks",
              "id":"#{task_1.id}",
              "attributes":{"title":"#{task_1.title}"},
              "relationships": {"tags": {"data": []}}
            }, {
              "type":"tasks",
              "id":"#{task_2.id}",
              "attributes":{"title":"#{task_2.title}"},
              "relationships": {"tags": {"data": [
                {"id":"#{tag_1.id}","type":"tags"},{"id":"#{tag_2.id}xxxx","type":"tags"}
              ]}}
            }
          ]}
        }
      end
    end
  end

end
