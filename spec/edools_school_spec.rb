# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::School do
  describe '#create' do
    context 'when valid school params' do
      let(:data) { { name: 'Test', email: 'test@test.com', password: '12345678' } }

      it 'returns an instance of Edools::School' do
        expect(Edools::School.create(data)).to be_an_instance_of Edools::School
      end
    end

    context 'when invalid school params' do
      let(:data) { { name: 'Test' } }

      it 'returns an instance of Edools::School' do
        expect(Edools::School.create(data)).to be_an_instance_of Edools::School
      end

      it 'has errors' do
        school = Edools::School.create(data)
        expect(school.errors).not_to be_empty
      end
    end
  end
end
