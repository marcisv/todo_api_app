require 'rails_helper'

RSpec.describe 'tags#update', type: :request do

  let!(:tag) { FactoryGirl.create(:tag, title: 'Urgent') }
  let(:new_tag_title) { 'Not so urgent' }

  it 'updates the tag name and returns the JSON data with status 200' do
    patch "/api/v1/tags/#{tag.id}", params: {data: {type: 'tags', id: 2, attributes: {title: new_tag_title}}}

    expect(response.status).to eq 200

    expect(response.body).to be_json_eql %{
      {"data":{
        "id":"#{tag.id}",
        "type":"tags",
        "attributes":{"title":"#{new_tag_title}"}
      }}
    }
  end

  context 'when parameters are not valid' do
    let(:new_tag_title) { '' }

    it 'returns errors with status 400' do
      patch "/api/v1/tags/#{tag.id}", params: {data: {type: 'tags', id: 2, attributes: {title: new_tag_title}}}

      expect(response.status).to eq 400
    end
  end

end
