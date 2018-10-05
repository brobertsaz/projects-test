require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let!(:products) { create_list(:product, 10) }
  let(:product_id) { products.first.id }

  describe 'GET /products' do
    before { get '/products' }

    it 'returns products' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /products/:id
  describe 'GET /products/:id' do
    before { get "/products/#{product_id}" }

    context 'when the record exists' do
      it 'returns the product' do
        expect(json).not_to be_empty
        expect( json['_id']['$oid']).to eq(product_id.to_s)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:product_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find product/)
      end
    end
  end


  describe 'POST /products' do
    let(:valid_attributes) { {
                              name: 'Snowboot Bag',
                              type: 'Ski',
                              length: 25,
                              width: 15,
                              height: 7,
                              weight: 25
                             } }

    context 'when the request is valid' do
      before { post '/products', params: valid_attributes }

      it 'creates a product' do
        expect(json['name']).to eq('Snowboot Bag')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/products', params: { name: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Type can't be blank/)
      end
    end
  end

  describe 'PUT /products/:id' do
    let(:valid_attributes) { {
      name: 'Snowboot Case',
      type: 'Ski',
      length: 25,
      width: 15,
      height: 7,
      weight: 25
     } }

    context 'when the record exists' do
      before { put "/products/#{product_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['name']).to eq 'Snowboot Case'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /products/:id' do
    before { delete "/products/#{product_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end