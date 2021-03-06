# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::Course do
  let(:school) { Edools::School.create name: 'Test', email: 'test@test.com', password: '12345678' }
  let(:course) { Edools::Course.create name: 'Test' }

  describe '.create' do
    context 'when valid params' do
      it 'returns an instance of Edools::Course' do
        VCR.use_cassette('course/create_valid') do
          school.set_as_global_environment
          expect(course).to be_an_instance_of Edools::Course
        end
      end
    end

    context 'when invalid params' do
      let(:course) { Edools::Course.create foo: '1' }

      it 'returns an instance of Edools::Course' do
        VCR.use_cassette('course/create_invalid_instance') do
          school.set_as_global_environment
          expect(course).to be_an_instance_of Edools::Course
        end
      end

      it 'has errors' do
        VCR.use_cassette('course/create_invalid_errors') do
          school.set_as_global_environment
          expect(course.errors).not_to be_empty
        end
      end
    end

    context 'when without params' do
      let(:course) { Edools::Course.create }

      it 'raises Edools::BadRequest' do
        VCR.use_cassette('course/create_no_params_bad_request') do
          school.set_as_global_environment
          expect { course }.to raise_error Edools::BadRequest
        end
      end
    end
  end

  describe '.all' do
    let(:all) { Edools::Course.all }

    it 'returns an array' do
      VCR.use_cassette('course/all') do
        school.set_as_global_environment
        expect(all).to be_instance_of Array
      end
    end
  end
end
