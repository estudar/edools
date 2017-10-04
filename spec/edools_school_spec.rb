# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::School do
  let(:school) { Edools::School.create name: 'Test', email: 'test@test.com', password: '12345678' }

  describe '.create' do
    context 'when valid params' do
      it 'returns an instance of Edools::School' do
        VCR.use_cassette('school/create_valid_instance') do
          expect(school).to be_an_instance_of Edools::School
        end
      end
    end

    context 'when invalid params' do
      let(:school) { Edools::School.create name: 'Test' }

      it 'returns an instance of Edools::School' do
        VCR.use_cassette('school/create_invalid_instance') do
          expect(school).to be_an_instance_of Edools::School
        end
      end

      it 'has errors' do
        VCR.use_cassette('school/create_invalid_errors') do
          expect(school.errors).not_to be_empty
        end
      end
    end
  end

  describe '.update' do
    context 'when valid params' do
      it 'succeeds' do
        VCR.use_cassette('school/update_valid') do
          preserving_environment do
            school.set_as_global_environment

            expect(Edools::School.update(id: school.id)).to be true
          end
        end
      end
    end

    context 'when school doesn\'t exist' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('school/update_not_found') do
          preserving_environment do
            school.set_as_global_environment

            expect { Edools::School.update id: 'test' }.to raise_error Edools::NotFound
          end
        end
      end
    end

    context 'when without params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('school/update_without_params') do
          preserving_environment do
            school.set_as_global_environment

            expect { Edools::School.update }.to raise_error ArgumentError
          end
        end
      end
    end
  end

  describe '#set_as_global_environment' do
    it 'sets the school as the global environment' do
      VCR.use_cassette('school/set_as_global_environment') do
        preserving_environment do
          school.set_as_global_environment

          expect(Edools.api_token).to eq school.credentials
        end
      end
    end
  end
end
