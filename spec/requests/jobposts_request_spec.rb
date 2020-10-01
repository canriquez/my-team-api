require 'rails_helper'

RSpec.describe "Jobposts API", type: :request do
    let!(:admin) {create(:admin_user)}
    let!(:admin1) {create(:admin_user)}
    let!(:headers_admin) { user_type_valid_headers(admin) }
    let!(:headers_admin1) { user_type_valid_headers(admin1) }

    let!(:user1) {create(:user_user)}
    let!(:headers_user1) { user_type_valid_headers(user1) }


    let!(:jobpost1) {create(:jobpost, author: admin)}
    let!(:jobpost2) {create(:jobpost, author: admin)}
    let(:jobpost_id) { jobposts.first.id}

    describe 'GET /jobposts' do

        context 'when user is admin and job post author' do
            before { get "/jobposts", params:{}, headers: headers_admin }
            it 'returns 2 jobposts' do
                expect(json).not_to be_empty
                expect(json.length).to eq(2)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when admin is not author in attributes' do
            before { get "/jobposts", params:{}, headers: headers_admin1 }
            it 'returns 0 jobposts' do
                expect(json).to be_empty
                expect(json.length).to eq(0)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when user attempts unauthorised access to jobposts' do
            before { get "/jobposts", params:{}, headers: headers_user1 }
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
            before { get "/jobposts/#{jobpost1.id}", params:{}, headers: headers_admin }
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
            #before { post '/signup', params: valid_attributes_admin.to_json, headers: headers }
            #before { post "/jobposts", params: valid_post_attributes.to_json, headers: headers_admin }

            it 'creates a new jobpost in database' do
                p valid_post_attributes
                p headers_admin
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


end
