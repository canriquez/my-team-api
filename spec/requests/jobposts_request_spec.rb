require 'rails_helper'

RSpec.describe "Jobposts API", type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:admin1) { create(:admin_user) }
  let!(:headers_admin) { user_type_valid_headers(admin) }
  let!(:headers_admin1) { user_type_valid_headers(admin1) }

  let!(:user1) { create(:user_user) }
  let!(:headers_user1) { user_type_valid_headers(user1) }

  let!(:jobpost1) { create(:jobpost, author: admin) }
  let!(:jobpost2) { create(:jobpost, author: admin) }
  let(:jobpost_id) { jobposts.first.id }

  describe 'GET /jobposts' do
    context 'when user is admin and job post author' do
      before { get "/jobposts", params: {}, headers: headers_admin }
      it 'returns 2 jobposts' do
        expect(json).not_to be_empty
        expect(json.length).to eq(2)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when admin is not author in attributes' do
      before { get "/jobposts", params: {}, headers: headers_admin1 }
      it 'returns 0 jobposts' do
        expect(json).to be_empty
        expect(json.length).to eq(0)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user attempts unauthorised access to jobposts' do
      before { get "/jobposts", params: {}, headers: headers_user1 }
      it 'returns a unauthorized message' do
        expect(json['message']).to match(/Sorry, you need 'admin' rights to access this resource/)
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /jobposts/:id' do
    context 'when user is admin and job post author' do
      before { get "/jobposts/#{jobpost1.id}", params: {}, headers: headers_admin }
      it 'returns 1 jobposts' do
        expect(json['jobpost']).not_to be_empty
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # create jobpost
  describe 'POST /jobposts/' do
    context 'creates a new job post with user_admin as author' do
      let(:valid_post_attributes) { FactoryBot.attributes_for(:jobpost, author_id: admin.id) }
      it 'creates a new jobpost in database' do
        expect do
          post "/jobposts", params: valid_post_attributes.to_json, headers: headers_admin
        end.to change(Jobpost, :count).by(1)
      end
      it 'returns success message' do
        post "/jobposts", params: valid_post_attributes.to_json, headers: headers_admin
        expect(json['message']).to match(/Success!. New Jobpost created./)
      end
    end
  end

  # Update method tests
  describe 'PUT /jobposts/:id' do
    # update jobpost done by author
    context 'Update jobpost :name with author valid attributes' do
      let(:admin) { create(:admin_user) }
      let(:oldjob) { create(:jobpost, author_id: admin.id) }
      let(:headers) { user_type_valid_headers(admin) }
      let(:valid_admin_data_change) { FactoryBot.attributes_for(:jobpost, name: 'Best jobpost') }

      before { put "/jobposts/#{oldjob.id}", params: valid_admin_data_change.to_json, headers: headers }

      it 'gets right status response 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to match(/successfull request/)
      end

      it 'returns user basic information' do
        expect(json['jobpost']['name']).to eq('Best jobpost')
      end
    end

    # fails to update admin's1 jobpost when admin2 attempts update
    context 'fails to Update jobpost :name with invalid admin author ' do
      let(:admin) { create(:admin_user) }
      let(:oldjob) { create(:jobpost, author_id: admin.id) }

      let(:admin2) { create(:admin_user) }
      let(:headers2) { user_type_valid_headers(admin2) }
      let(:valid_admin_data_change) { FactoryBot.attributes_for(:jobpost, name: 'Best jobpost') }

      before { put "/jobposts/#{oldjob.id}", params: valid_admin_data_change.to_json, headers: headers2 }

      it 'gets status response 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns unauthorised request message' do
        expect(json['message']).to match(/Unauthorized request/)
      end
    end

    # fails to update admin's1 jobpost when normal user attempts update
    context 'fails to Update jobpost :name with user role ' do
      let(:admin) { create(:admin_user) }
      let(:oldjob) { create(:jobpost, author_id: admin.id) }

      let(:user1) { create(:user_user) }
      let(:headers) { user_type_valid_headers(user1) }
      let(:valid_admin_data_change) { FactoryBot.attributes_for(:jobpost, name: 'Best jobpost') }

      before { put "/jobposts/#{oldjob.id}", params: valid_admin_data_change.to_json, headers: headers }

      it 'gets status response 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns unauthorised request message' do
        expect(json['message']).to match(/Sorry, you need 'admin' rights to access this resource/)
      end
    end
  end

  # Destroy method tests
  describe 'DELETE /jobposts/:id' do
    context 'with author valid attributes' do
      let(:admin) { create(:admin_user) }
      let(:oldjob) { create(:jobpost, author_id: admin.id) }
      let(:headers) { user_type_valid_headers(admin) }

      before { delete "/jobposts/#{oldjob.id}", headers: headers }

      it 'gets right status response 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to match(/successfull destroy request/)
      end

      it 'returns user basic information' do
        expect(json['jobpost']['name']).to eq(oldjob.name)
      end
    end

    context 'with author invalid attributes' do
      let(:admin) { create(:admin_user) }
      let(:oldjob) { create(:jobpost, author_id: admin.id) }

      let(:admin2) { create(:admin_user) }
      let(:headers2) { user_type_valid_headers(admin2) }

      before { delete "/jobposts/#{oldjob.id}", headers: headers2 }

      it 'gets status response 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Unauthorized request/)
      end
    end

    context 'with role user invalid attributes' do
      let(:admin) { create(:admin_user) }
      let(:oldjob) { create(:jobpost, author_id: admin.id) }

      let(:user1) { create(:user_user) }
      let(:headers) { user_type_valid_headers(user1) }

      before { delete "/jobposts/#{oldjob.id}", headers: headers }

      it 'gets status response 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Unauthorized request/)
      end
    end
  end
end
