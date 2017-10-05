require 'rails_helper'

RSpec.describe 'tags#create', type: :request do

  let(:tag_title) { 'Urgent' }

  it 'persists the tag and returns the JSON data with status 201' do
    post '/api/v1/tags', params: {data: {attributes: {title: tag_title}}}

    expect(response.status).to eq 201
    expect(response.body).to have_json_type(String).at_path('data/id')

    tag = Tag.find_by(id: parse_json(response.body, 'data/id'))

    expect(tag).to be_present
    expect(tag.title).to eq tag_title

    expect(response.body).to be_json_eql %{
      {"data":{
        "id":"#{tag.id}",
        "type":"tags",
        "attributes":{"title":"#{tag.title}"}
      }}
    }
  end

  context 'when parameters are not valid' do
    let(:tag_title) { '' }

    it 'returns errors with status 400' do
      post '/api/v1/tags', params: {data: {attributes: {title: tag_title}}}

      expect(response.status).to eq 400
    end
  end

end
