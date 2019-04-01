require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }
  describe 'GET /todos' do
    before  {get '/todos'}
     it 'returns todos' do
       expect(json).not_to be_empty
       expect(json.size).to eq(10)
     end

     it 'returns status code 200' do
       expect(response).to have_http_status(200)
     end
  end

  describe 'GET /todos/:id' do
    before {get '/todos/:#{todo_id}',params: valid_attributes }

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
      it 'returns a status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match('/Could not find the todo')
      end
    end
  end
end