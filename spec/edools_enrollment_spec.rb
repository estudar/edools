# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::Enrollment do
    let(:enrollment) { Edools::Enrollment.create registration_id: '6479697',
                  school_product_id: '73636',
                  max_attendance_type: "indeterminate"
    }

  describe '.create' do
    context 'when valid params' do
      it 'returns an instance of Edools::Enrollment' do
        VCR.use_cassette('enrollment/create_valid_instance') do
          expect(enrollment).to be_an_instance_of Edools::Enrollment
        end
      end
    end
  end

  describe '.update' do
    context 'when valid params' do
      it 'succeeds' do
        VCR.use_cassette('enrollment/update_valid') do
          expect(Edools::Enrollment.update(id: 2022188)).to be true
        end
      end
    end

    context 'when enrollment doesn\'t exist' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('enrollment/update_not_found') do
          expect { Edools::Enrollment.update id: 'test' }.to raise_error Edools::NotFound
        end
      end
    end

    context 'when without params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('enrollment/update_without_params') do
          expect { Edools::Enrollment.update }.to raise_error ArgumentError
        end
      end
    end
  end
end
