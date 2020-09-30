require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
    
    let(:user) { create(:user_user)}

    # build fake 'authorization' header with user info
    let(:header) { {'Authorization' => token_generator(user.id)}}

    # Invalid request subject
    subject(:invalid_request_obj) { described_class.new({}) }

    #Valid request subject
    subject(:request_obj) { described_class.new(header)}


    # #call method tests, 
    # used to return User object 
    # when request is valid
    
    describe '#call' do
        context 'when valid request' do
            it 'returns user object' do
                result = request_obj.call
                expect(result[:user]).to eq(user)
            end
        end

        #retutns error with invalid request

        context 'when invalid request' do
            context 'when missing token' do
                it 'raises a MissingToken error' do
                    expect {invalid_request_obj.call}
                    .to raise_error(ExceptionHandler::MissingToken, 'Authentication Missing')
                end
            end

            context 'when invalid token' do
                subject(:invalid_request_obj) do
                    #using custome method 'token generator'
                    described_class.new('Authorization'=> token_generator(5))
                end

                it 'raises an InvalidToken error' do
                    expect {invalid_request_obj.call}
                    .to raise_error(ExceptionHandler::InvalidToken, /mmmm, token invalid, are you a hacker?/)
                end
            end


            context 'when token is expired' do
                let(:header) {{'Authorization'=> expired_token_generator(user.id)}}
                subject(:request_obj) {described_class.new(header)}

                it 'raises ExceptionHandler::ExpiredSignature error' do
                    expect {request_obj.call}
                    .to raise_error(
                        ExceptionHandler::InvalidToken,
                        /Signature has expired/
                    )
                end
            end

            context 'fake token wow' do
                let(:header) {{'Authorization'=> 'iamafaketokenjajajaja'}}
                subject(:invalid_request_obj) {described_class.new(header)}

                it 'handles JWT::DecodeError' do
                    expect {invalid_request_obj.call}
                    .to raise_error(
                        ExceptionHandler::InvalidToken,
                        /Not enough or too many segments/
                    )
                end
            end

        end
    end

end