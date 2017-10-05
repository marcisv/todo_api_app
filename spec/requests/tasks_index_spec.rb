require 'rails_helper'

RSpec.describe 'tasks#index', type: :request do

  it 'returns data with empty array' do
    get '/api/v1/tasks'

    expect(response.body).to be_json_eql %{{"data":[]}}
  end

  context 'when some tasks exist' do
    let!(:task1) { FactoryGirl.create(:task) }
    let!(:task2) { FactoryGirl.create(:task) }

    it 'returns data with the tasks' do
      get '/api/v1/tasks'

      expect(response.body).to be_json_eql %{
        {"data":[
          {
            "type":"tasks",
            "id":"#{task1.id}",
            "attributes":{"title":"#{task1.title}"}
          }, {
            "type":"tasks",
            "id":"#{task2.id}",
            "attributes":{"title":"#{task2.title}"}
          }
        ]}
      }
    end
  end

end
