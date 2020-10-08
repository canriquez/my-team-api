require 'rails_helper'

RSpec.describe "Adminhomes", type: :request do
  # get active applications with all admin_home required information details
  describe 'GET active /likes' do
    let!(:admin1) { create(:admin_user, name: 'Carlos') }
    let!(:headers_admin1) { user_type_valid_headers(admin1) }
    let!(:admin2) { create(:admin_user, name: 'Carlos') }
    let!(:headers_admin2) { user_type_valid_headers(admin2) }

    let!(:user1) { create(:user_user, name: 'Carlos') }
    let!(:user2) { create(:user_user, name: 'Carlos') }
    let!(:headers_user1) { user_type_valid_headers(user1) }

    let!(:jobpost1) { create(:jobpost, author: admin1) }

    let!(:application1) { create(:application, jobpost: jobpost1, applicant_id: user1.id) }
    let!(:application2) { create(:application, jobpost: jobpost1, applicant_id: user2.id) }

    let!(:like_a1_01) { create(:like, evaluation: 'like', application_id: application1.id, admin_id: admin1.id) }
    let!(:like_a1_02) { create(:like, evaluation: 'dislike', application_id: application1.id, admin_id: admin2.id) }

    context 'when role is :admin ' do
      before { get "/adhome", headers: headers_admin1 }
      it 'returns all job' do
        expect(json).not_to be_empty
        expect(json.length).to eq(2)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns user admin information' do
        expect(json[1]['applicant_name']).to eq('Carlos')
      end
    end

    context 'when role is :user ' do
      before { get "/adhome", headers: headers_user1 }

      it 'gets status response 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns unauthorization message' do
        expect(json['message']).to eq("Sorry, you need 'admin' rights to access this resource")
      end
    end
  end

  describe 'GET total User likes/dislikes ' do
    let!(:admin1) { create(:admin_user, name: 'Carlos') }
    let!(:headers_admin1) { user_type_valid_headers(admin1) }
    let!(:admin2) { create(:admin_user, name: 'Carlos') }
    let!(:headers_admin2) { user_type_valid_headers(admin2) }

    let!(:user1) { create(:user_user, name: 'Carlos') }
    let!(:user2) { create(:user_user, name: 'Carlos') }
    let!(:headers_user1) { user_type_valid_headers(user1) }

    let!(:jobpost1) { create(:jobpost, author: admin1) }

    let!(:application1) { create(:application, jobpost: jobpost1, applicant_id: user1.id) }
    let!(:application2) { create(:application, jobpost: jobpost1, applicant_id: user2.id) }

    let!(:like_a1_01) { create(:like, evaluation: 'like', application_id: application1.id, admin_id: admin1.id) }
    let!(:like_a1_02) { create(:like, evaluation: 'dislike', application_id: application2.id, admin_id: admin1.id) }

    let!(:params) { { id: admin1.id } }

    context 'when role is :admin ' do
      before { post "/adhome/evals/", params: params.to_json, headers: headers_admin1 }
      it 'returns all evaluations' do
        puts "HERE JSON"
        p json
        expect(json).not_to be_empty
        expect(json.length).to eq(2)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns user admin information' do
        puts "HERE JSON"
        p json
        expect(json[0]['admin_id']).to eq(admin1.id)
      end
    end

    context 'when role is :user ' do
      before { post "/adhome/evals/", params: params.to_json, headers: headers_user1 }

      it 'gets status response 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns unauthorization message' do
        expect(json['message']).to eq("Sorry, you need 'admin' rights to access this resource")
      end
    end
  end

  # checkSignUpEmail | checkSignUpEmail
  describe 'GET /check/:email' do
    # update name test
    context 'check for existing email' do
      let(:user) { create(:user_user) }
      let(:headers) { valid_headers.except('Authorization') }
      let!(:params) { { email: user.email } }

      before { post "/adhome/check/", params: params.to_json, headers: headers }

      it 'gets right status response 200' do
        puts '-|||-- check email for signup---|||'
        p json
        expect(response).to have_http_status(200)
      end

      it 'returns taken message response' do
        expect(json['message']).to eq("taken")
      end
    end

    context 'check for available email' do
      let(:user) { create(:user_user) }
      let(:headers) { valid_headers.except('Authorization') }
      let!(:params) { { email: 'newUser@gmail.com' } }

      before { post "/adhome/check/", params: params.to_json, headers: headers }

      it 'gets right status response 200' do
        puts '-|||-- check email for signup---|||'
        p json
        expect(response).to have_http_status(200)
      end

      it 'returns taken message response' do
        expect(json['message']).to eq("newUser@gmail.com available")
      end
    end
  end
end
