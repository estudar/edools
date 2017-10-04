# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::Invitation do
  let(:school) { Edools::School.create name: 'Test', email: 'test@test.com', password: '12345678' }
  let(:invitation) { Edools::Invitation.create first_name: 'test', email: 'student@test.com', password: '123456', password_confirmation: '123456' }

  describe '.create' do
    context 'when valid params' do
      it 'returns an instance of Edools::Invitation' do
        VCR.use_cassette('invitation/create_valid') do
          school.set_as_global_environment
          expect(invitation).to be_an_instance_of Edools::Invitation
        end
      end
    end

    context 'when invalid params' do
      let(:invitation) { Edools::Invitation.create foo: '1' }

      it 'returns an instance of Edools::Invitation' do
        VCR.use_cassette('invitation/create_invalid_instance') do
          school.set_as_global_environment
          expect(invitation).to be_an_instance_of Edools::Invitation
        end
      end

      it 'has errors' do
        VCR.use_cassette('invitation/create_invalid_errors') do
          school.set_as_global_environment
          expect(invitation.errors).not_to be_empty
        end
      end
    end

    # Left this out because the API is throwing error 500

    # context 'when without params' do
    #   let(:invitation) { Edools::Invitation.create }

    #   it 'raises Edools::BadRequest' do
    #     school.set_as_global_environment
    #     expect { invitation }.to raise_error Edools::BadRequest
    #   end
    # end
  end
end
