require 'rails_helper'

RSpec.describe "Users", type: :request do

    # initialize test data
  let!(:users) { create_list(:user_user, 10) }
  let(:user_id) { users.first.id }

   # GET /users
   describe 'GET /users' do
    # HTTP get request 
    before { get '/users' }

    it 'returns users' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

end
