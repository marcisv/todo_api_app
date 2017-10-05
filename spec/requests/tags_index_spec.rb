require 'rails_helper'

RSpec.describe 'tags#index', type: :request do

  it 'returns data with empty array' do
    get '/api/v1/tags'

    expect(response.body).to be_json_eql %{{"data":[]}}
  end

  context 'when some tags exist' do
    let!(:tag1) { FactoryGirl.create(:tag) }
    let!(:tag2) { FactoryGirl.create(:tag) }

    it 'returns data with the tags' do
      get '/api/v1/tags'

      expect(response.body).to be_json_eql %{
        {"data":[
          {
            "type":"tags",
            "id":"#{tag1.id}",
            "attributes":{"title":"#{tag1.title}"}
          }, {
            "type":"tags",
            "id":"#{tag2.id}",
            "attributes":{"title":"#{tag2.title}"}
          }
        ]}
      }
    end
  end

end
