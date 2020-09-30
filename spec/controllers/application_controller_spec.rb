require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
    

    let!(:user) { create(:user_user) }

    #build authorization headers
    let(:headers) {{'Authorization'=> token_generator(user.id)}}
    let(:invalid_headers) {{'Authorization'=> nil}}

    describe "#authenticate request" do
        context "when valid auth token is passed" do
            before { allow(request).to receive(:headers).and_return(headers) }

            it "sets the current user" do
                p subject.instance_eval {authorize_request}
                expect(subject.instance_eval {authorize_request}).to eq(user)
            end
        end
    end

end