require 'rails_helper'

RSpec.describe "Users", type: :request do
  # initialize test data
  let(:user) { build(:user_user) }
  let(:admin) { build(:admin_user) }
  # Build equates to #new metod. It submit properties and

  # builds headers with no Authorization property on it to simulate the signup post
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes_admin) do
    attributes_for(:admin_user)
  end

  let(:valid_attributes_user) do
    attributes_for(:user_user)
  end

  # signup test for admin
  describe 'POST /signup' do
    context 'when admin valid attributes' do
      before { post '/signup', params: valid_attributes_admin.to_json, headers: headers }

      it 'creates a new user' do
        p headers
        p valid_attributes_admin
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Success! - Account has been created./)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    #signup test for user
    context 'when user valid attributes' do
      before { post '/signup', params: valid_attributes_user.to_json, headers: headers }

      it 'creates a new user' do
        p headers
        p valid_attributes_user
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Success! - Account has been created./)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    #show test for user
    context 'when user valid attributes' do
      let(:user) {create(:user_user)}
      let(:headers) { valid_headers }
      before { get "/users/#{user.id}", headers: headers }

      it 'shows basic user information' do
        puts '-|||-- show test ---|||'
        p headers
        p valid_attributes_user
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to match(/successfull request/)
      end

      it 'returns user basic information' do
        expect(json['user'][0]['id']).to eq(user.id)
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failures message' do
        expect(json['message'])
          .to match(`Validation failed: Password can't
            be blank, Email can't be blank, Email The email is not valid,
             Name can't be blank, Avatar can't be blank, Role can't be blank`)
      end
    end


    #update name test
    context 'Update when user :name with valid attributes' do
      let(:user) {create(:user_user)}
      let(:headers) { valid_headers }
      let(:valid_user_data_change) { FactoryBot.attributes_for(:user_user, name: 'pedro') }

      before { put "/users/#{user.id}", params: valid_user_data_change.to_json, headers: headers }

      it 'gets right status response 200' do
        puts '-|||-- update name test ---|||'
        p headers
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to match(/successfull request/)
      end

      it 'returns user basic information' do
        expect(json['user'][0]['name']).to eq('pedro')
      end
    end

    #update name when user not the owner
    context 'Update when user :name when user is not the owner' do
      let(:user) {create(:user_user)}
      let(:user1) {create(:user_user)}
      let(:headers) { valid_headers }
      let(:valid_user_data_change) { FactoryBot.attributes_for(:user_user, name: 'pedro') }

      before { put "/users/#{user1.id}", params: valid_user_data_change.to_json, headers: headers }

      it 'fails to get right status response 200' do
        puts "-|||-- update other's name test ---|||"
        p headers
        expect(response).not_to have_http_status(200)
      end

      it 'fails to returns success message' do
        expect(json['message']).to match(/Unauthorized request/)
      end

    end

  end
end
