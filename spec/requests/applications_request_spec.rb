require 'rails_helper'

RSpec.describe "Applications API", type: :request do

    describe 'GET /applications' do
        let!(:admin) {create(:admin_user)}
        let!(:headers_admin) { user_type_valid_headers(admin) }
    
        let!(:user1) {create(:user_user)}
        let!(:user2) {create(:user_user)}
        let!(:headers_user1) { user_type_valid_headers(user1) }

        let!(:jobpost1) {create(:jobpost, author: admin)}

        let!(:application1) {create(:application, jobpost: jobpost1, applicant_id: user1.id)}
        let!(:application2) {create(:application, jobpost: jobpost1, applicant_id: user2.id)}
        #let(:jobpost1_id) { applications.first.id}

        context 'when user is admin ' do
            before { get "/applications", params:{}, headers: headers_admin }
            it 'returns all job applications' do
                puts '||||| headers on index request |||||'
                p headers_admin
                p json
                expect(json).not_to be_empty
                expect(json.length).to eq(2)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when user attempts unauthorised access to applications' do
            before { get "/applications", params:{}, headers: headers_user1 }
            it 'returns a unauthorized message' do
                expect(json['message']).to match(/Sorry, you need 'admin' rights to access this resource/)
            end

            it 'returns status code 401' do
                expect(response).to have_http_status(401)
            end
        end
    end

    #gets specific application 
    describe 'GET /applications/:id' do
        let!(:admin) {create(:admin_user)}
        let!(:headers_admin) { user_type_valid_headers(admin) }
    
        let!(:user1) {create(:user_user)}
        let!(:user2) {create(:user_user)}
        let!(:headers_user1) { user_type_valid_headers(user1) }
        let!(:headers_user2) { user_type_valid_headers(user2) }

        let!(:jobpost1) {create(:jobpost, author: admin)}

        let!(:application1) {create(:application, jobpost: jobpost1, applicant_id: user1.id)}
        let!(:application2) {create(:application, jobpost: jobpost1, applicant_id: user2.id)}
        #let(:jobpost1_id) { applications.first.id}

        context 'when user is admin ' do
            before { get "/applications/#{application1.id}", params:{}, headers: headers_admin }
            it 'returns all job applications' do
                puts '||||| headers on index request |||||'
                p headers_admin
                p json
                expect(json).not_to be_empty
                expect(json['application']['id']).to eq(application1.id)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when user is the owner applicant ' do
            before { get "/applications/#{application1.id}", params:{}, headers: headers_user1 }
            it 'returns a successfull message' do
                expect(json['message']).to match(/successfull request/)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when user is not the owner applicant' do
            before { get "/applications/#{application1.id}", params:{}, headers: headers_user2 }
            it 'returns a unauthorized message' do
                expect(json['message']).to match(/Sorry, only 'owner' or 'admin' can access this resource/)
            end

            it 'returns status code 401' do
                expect(response).to have_http_status(401)
            end
        end
    end


end
