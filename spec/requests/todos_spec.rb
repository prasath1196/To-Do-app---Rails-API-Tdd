require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 10, created_by: user.id) }
  let(:todo_id) { todos.first.id }
  let(:headers) {valid_headers}
  describe 'GET /todos' do
    before  {get '/todos',params:{},headers:headers}
     it 'returns todos' do
       expect(json).not_to be_empty
       expect(json.size).to eq(10)
     end

     it 'returns status code 200' do
       expect(response).to have_http_status(200)
     end
  end

  describe 'GET /todos/:id' do
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }
    before {get "/todos/#{todo_id}",params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }
      it 'returns a status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end
  describe 'Post /todos' do
    let(:valid_attributes) do
      { title: 'Learn Elm', created_by: user.id.to_s }.to_json
    end
    context 'when data is valid' do
      before { post '/todos', params: valid_attributes, headers: headers }

      it 'Creates todo' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when data is invalid' do
      let(:invalid_attributes) { { title: nil }.to_json }
      before { post '/todos', params: invalid_attributes, headers: headers }

      it 'returns a validation failure message' do
        expect(json['message'])
            .to match(/Validation failed: Title can't be blank/)
      end

      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' }.to_json }
    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers }
      it 'updates the record ' do
        expect(response.body).to be_empty
      end
      it 'returns the status 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}",params:{},headers: headers }
    it 'returns status 204' do
      expect(response).to have_http_status(204)
    end
  end

end