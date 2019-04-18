require 'rails_helper'
RSpec.describe 'Items API' do
  let(:user) { create(:user) }
  let!(:todo) { create(:todo, created_by: user.id) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }
  let(:headers){valid_headers}

  # Test suite for GET /todos/:todo_id/items
  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items", params:{},headers:headers }

    context 'when todo exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all todo items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when todo does not exist' do
      let(:todo_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe "Get /todos/:todo_id/items/:id" do
    before {get "/todos/#{todo_id}/items/#{id}",params:{}, headers:headers}
    context 'when todo item exists' do
      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the todo item' do
        expect(json['id']).to eq(id)
      end
    end
    context 'when todo item does not exist' do
      let!(:id){0}
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns could not find message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'POST /todos/:todo_id/items' do
    let!(:valid_attributes) {{name:"Test item", done:false}.to_json}
    context 'when request data is valid' do
      before do
        post "/todos/#{todo_id}/items",params: valid_attributes, headers:headers
      end
      it 'returns a status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    context 'when request data is invalid' do
      before {post "/todos/#{todo_id}/items",params: {}, headers:headers}
      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a validation failed message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /todos/:todo_id/items/:id' do
    let(:valid_attributes) { {name:"NameChanged"}.to_json }
    before {put "/todos/#{todo_id}/items/#{id}",params: valid_attributes,headers:headers}
    context 'when the item exists' do
      it 'returns the status code 204' do
        expect(response).to have_http_status(204)
      end
      it 'updates the item' do
          updated_item = Item.find(id)
          expect(updated_item.name).to match(/NameChanged/)
      end
    end
    context 'when the item does not exist' do
      let(:id) { 0 }
      it 'returns the status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns failure message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
  describe 'DELETE /todos/:id' do
    before do
      delete "/todos/#{todo_id}/items/#{id}",params:{},headers:headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
