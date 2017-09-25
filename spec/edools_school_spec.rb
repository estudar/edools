# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::School do
  let(:school) { Edools::School.create name: 'Test', email: 'test@test.com', password: '12345678' }
  describe '.create' do
    context 'when valid school params' do
      it 'returns an instance of Edools::School' do
        expect(school).to be_an_instance_of Edools::School
      end
    end

    context 'when invalid school params' do
      let(:school) { Edools::School.create name: 'Test' }

      it 'returns an instance of Edools::School' do
        expect(school).to be_an_instance_of Edools::School
      end

      it 'has errors' do
        expect(school.errors).not_to be_empty
      end
    end
  end

  describe '#set_as_global_environment' do
    it 'sets the school as the global environment' do
      preserving_environment do
        school.set_as_global_environment

        expect(Edools.api_token).to eq school.credentials
        expect(Edools.subdomain).to eq school.subdomain
      end
    end
  end
end
