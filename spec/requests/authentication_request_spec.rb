require 'rails_helper'

RSpec.describe "Authentication", type: :request do

    describe 'POST /auth/login' do
        
        let!(:user) { create(:user_user) }

        #builds authorization headers

        let(:headers) { valid_headers.except('Authorization')}

        #creates credentials

        let(:valid_credentials) do
            {
                email: user.email,
                password: user.password
            }.to_json
        end

        let(:invalid_credentials) do 
            {
                email: Faker::Internet.email,
                password: Faker::Internet.password
            }.to_json
        end

        #successful login, retrutns token

        context 'When request is valid' do
            before { post '/auth/login', params: valid_credentials, headers: headers}

            it 'returns an authentication token' do
                expect(json['auth_token']).not_to be_nil
            end
        end

        #failed login, returns error message

        context 'When request is invalid' do
            before { post '/auth/login', params: invalid_credentials, headers: headers }

            it 'returns a error message' do
                expect(json['message']).to match(/Invalid credentials/)
            end
        end

    end

end
