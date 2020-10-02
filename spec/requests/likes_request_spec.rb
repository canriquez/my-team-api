require 'rails_helper'

RSpec.describe "Likes", type: :request do

        #get active likes (where application and job exists) total list 
        describe 'GET active /likes' do
            let!(:admin1) {create(:admin_user)}
            let!(:headers_admin1) { user_type_valid_headers(admin1) }
            let!(:admin2) {create(:admin_user)}
            let!(:headers_admin2) { user_type_valid_headers(admin2) }
        
            let!(:user1) {create(:user_user)}
            let!(:user2) {create(:user_user)}
            let!(:headers_user1) { user_type_valid_headers(user1) }
    
            let!(:jobpost1) {create(:jobpost, author: admin1)}
    
            let!(:application1) {create(:application, jobpost: jobpost1, applicant_id: user1.id)}
            let!(:application2) {create(:application, jobpost: jobpost1, applicant_id: user2.id)}

            let!(:like_a1_01) {create(:like, evaluation: 'like', application_id: application1.id, admin_id: admin1.id)}
            let!(:like_a1_02) {create(:like, evaluation: 'dislike', application_id: application1.id, admin_id: admin1.id)}
    
            context 'when role is :admin ' do
                before { get "/likes", headers: headers_admin1 }
                it 'returns all job' do
                    puts '||||| headers on index request |||||'
                    p headers_admin1
                    p json
                    expect(json).not_to be_empty
                    expect(json.length).to eq(2)
                end
    
                it 'returns status code 200' do
                    expect(response).to have_http_status(200)
                end
            end
    
            context 'when role is :user ' do
                before { get "/likes", headers: headers_user1 }
    
                it 'returns status code 401' do
                    expect(response).to have_http_status(401)
                end

                it 'returns unauthenticated message' do
                    expect(json['message']).to match(/Sorry, you need 'admin' rights to access this resource/)
                end
            end
        end

     # create like
     describe 'POST /likes/' do

        let!(:admin1) {create(:admin_user)}
        let!(:headers_admin1) { user_type_valid_headers(admin1) }
        let!(:admin2) {create(:admin_user)}
        let!(:headers_admin2) { user_type_valid_headers(admin2) }
    
        let!(:user1) {create(:user_user)}
        let!(:user2) {create(:user_user)}
        let!(:headers_user1) { user_type_valid_headers(user1) }

        let!(:jobpost1) {create(:jobpost, author: admin1)}

        let!(:application1) {create(:application, jobpost: jobpost1, applicant_id: user1.id)}
        let!(:application2) {create(:application, jobpost: jobpost1, applicant_id: user2.id)}


        context 'create like record with valid credentials and :admin role' do
            let(:valid_post_attributes) {FactoryBot.attributes_for(:like, evaluation: 'like', application_id: application1.id, admin_id: admin1.id) }
            it 'creates like' do
                expect do
                    post "/likes", params: valid_post_attributes.to_json, headers: headers_admin1
                end.to change(Like, :count).by(1)
            end
            it 'returns success message' do
                post "/likes", params: valid_post_attributes.to_json, headers: headers_admin1
                puts ' ======= JSON response ====='
                p json
                expect(json['message']).to eq("+1")
            end
        end

        context 'create like record with valid credentials and :user role' do
            let(:valid_post_attributes) {FactoryBot.attributes_for(:like, evaluation: 'like', application_id: application1.id, admin_id: admin1.id) }
            it 'fails to creates like' do
                expect do
                    post "/likes", params: valid_post_attributes.to_json, headers: headers_user1
                end.to change(Like, :count).by(0)
            end
            it 'returns unauthorised message' do
                post "/likes", params: valid_post_attributes.to_json, headers: headers_user1
                puts ' ======= JSON response ====='
                p json
                expect(json['message'])
                .to match(/Sorry, you need 'admin' rights to access this resource/)
            end
        end


        context 'Create action for same :admin_id & :application_id record' do

            let(:valid_post_attributes) {FactoryBot.attributes_for(:like, evaluation: 'like', application_id: application1.id, admin_id: admin1.id) }
            it 'fails to creates a duplicated like record in database ' do
                post "/likes", params: valid_post_attributes.to_json, headers: headers_admin1
                expect do
                    post "/likes", params: valid_post_attributes.to_json, headers: headers_admin1
                end.to change(Like, :count).by(0)
            end
            it 'returns failure message' do
                post "/likes", params: valid_post_attributes.to_json, headers: headers_admin1
                post "/likes", params: valid_post_attributes.to_json, headers: headers_admin1
                expect(json['message'])
                .to eq("Validation failed: Application should have only one like/dislike record per :admin user.")
            end
        end

    end    
end
