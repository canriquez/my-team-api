require 'rails_helper'

RSpec.describe "Applications API", type: :request do

    #get application's total list 
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
            before { get "/applications", headers: headers_admin }
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
                puts '||||| headers on index request - unauthorised |||||'
                p headers_admin
                p json
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
            it 'returns the job application info' do
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
                expect(json['message']).to match(/Sorry, only 'owner' or 'admin' can execute this action/)
            end

            it 'returns status code 401' do
                expect(response).to have_http_status(401)
            end
        end
    end

     # create jobpost
    describe 'POST /applications/' do

        let!(:admin) {create(:admin_user)}
        let!(:headers_admin) { user_type_valid_headers(admin) }
    
        let!(:user1) {create(:user_user)}
        let!(:headers_user1) { user_type_valid_headers(user1) }
        let!(:headers_invalid_user1) { user_type_valid_headers(user1).except('Authorization') }

        let!(:jobpost1) {create(:jobpost, author: admin)}


        context 'creates a new application with :user role as applicant and valid credentials' do
            let(:valid_post_attributes) { FactoryBot.attributes_for(:application, jobpost_id: jobpost1.id, applicant_id: user1.id) }
            it 'creates a new jobpost in database' do
                expect do
                    post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                end.to change(Application, :count).by(1)
            end
            it 'returns success message' do
                post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                expect(json['message']).to match(/Success!. You have applied for the Job./)
            end
        end

        context 'creates a new application with :user role as applicant and valid credentials' do
            let(:valid_post_attributes) { FactoryBot.attributes_for(:application, jobpost_id: jobpost1.id, applicant_id: user1.id) }
            it 'creates a new jobpost in database' do
                expect do
                    post "/applications", params: valid_post_attributes.to_json, headers: headers_invalid_user1
                end.to change(Application, :count).by(0)
            end
            it 'returns unauthorised message' do
                post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                expect(json['message']).to match(/Success!. You have applied for the Job./)
            end
        end

        context 'Attept to creates application with :user role and INVALID credentials' do
            let(:valid_post_attributes) { FactoryBot.attributes_for(:application, jobpost_id: jobpost1.id, applicant_id: user1.id) }
            it 'fails to creates a new jobpost in database' do
                expect do
                    post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                end.to change(Application, :count).by(1)
            end
            it 'returns success message' do
                post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                expect(json['message']).to match(/Success!. You have applied for the Job./)
            end
        end

        context 'Re-applies to the same job post with Valid credentials' do

            let(:valid_post_attributes) { FactoryBot.attributes_for(:application, jobpost_id: jobpost1.id, applicant_id: user1.id) }
            it 'fails to creates a duplicated jobpost in database' do
                post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                expect do
                    post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                end.to change(Application, :count).by(0)
            end
            it 'returns failure message' do
                post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                post "/applications", params: valid_post_attributes.to_json, headers: headers_user1
                expect(json['message']).to match(/Validation failed: Applicant has already been taken/)
            end
        end

    end

    # Destroy method tests
    describe 'DELETE /applications/:id' do

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

        context 'with author valid attributes' do
    
            before { delete "/applications/#{application1.id}", headers: headers_user1 }
    
            it 'gets right status response 200' do
            expect(response).to have_http_status(200)
            end
    
            it 'returns success message' do
            expect(json['message']).to match(/successfull destroy request/)
            end
    
            it 'returns user basic information' do
                expect(json['application']['id']).to eq(application1.id)
            end
        end

        context 'with admin valid attributes' do
            before { delete "/applications/#{application1.id}", headers: headers_admin }
    
            it 'gets status response 200' do
                expect(response).to have_http_status(200)
            end
    
            it 'returns success basic info' do
                expect(json['application']['id']).to eq(application1.id)
            end
        end

        context 'with role user invalid attributes' do    
            before { delete "/applications/#{application1.id}", headers: headers_user2 }
    
            it 'gets status response 401' do
            expect(response).to have_http_status(401)
            end
    
            it 'returns unauthorised message' do
            expect(json['message']).to match(/Sorry, only 'owner' or 'admin' can execute this action/)
            end
        end
    end
    
    #disable application
    describe 'PUT /applications/:id' do
        let!(:admin) {create(:admin_user)}
        let!(:headers_admin) { user_type_valid_headers(admin) }
    
        let!(:user1) {create(:user_user)}
        let!(:user2) {create(:user_user)}
        let!(:headers_user1) { user_type_valid_headers(user1) }

        let!(:jobpost1) {create(:jobpost, author: admin)}

        let!(:application1) {create(:application, jobpost_id: jobpost1.id, applicant_id: user1.id)}
        let!(:application2) {create(:application, jobpost_id: jobpost1.id, applicant_id: user2.id)}

        #valid updates can only change :enabled property
        let(:valid_data_change1) {FactoryBot.attributes_for(:application, jobpost_id: jobpost1.id, applicant_id: user1.id, enabled: false) }
        let(:invalid_data_change) { FactoryBot.attributes_for(:application, enabled: false) }

        #update application1 done by author
        context 'Update application1 :enabled with admin valid attributes' do

            before { put "/applications/#{application1.id}", params: valid_data_change1.to_json, headers: headers_admin }
    
            it 'gets right status response 200' do
                puts ' |------------------ ATTEMPT TO APPLY THIS CHANGES ----------------- | '
                p valid_data_change1
                puts 'Application1 data:'
                p application1
                puts ' |------------------ ============================== ----------------- | '


            expect(response).to have_http_status(200)
            end
    
            it 'returns success message' do
            expect(json['message']).to match(/successfull request/)
            end
    
            it 'returns user basic information' do
                puts '====== JSON RESPONSE===== '
                p json['application']['enabled']
            expect(json['application']['enabled']).to eq(false)
            end
        end

        #fails to update when role is user
        context 'fails to Update application1 :enabled with role :user ' do
    
            before { put "/applications/#{application1.id}", params: valid_data_change1.to_json, headers: headers_user1 }
    
            it 'gets unauthorised response 401' do
                puts ' |------------------ ATTEMPT TO APPLY THIS CHANGES ----------------- | '
                p valid_data_change1
                puts 'Application1 data:'
                p application1
                puts ' |------------------ ============================== ----------------- | '


            expect(response).to have_http_status(401)
            end
    
            it 'returns only admin message' do
            expect(json['message']).to match(/Sorry, you need 'admin' rights to access this resource/)
            end
    
        end
    end

end
