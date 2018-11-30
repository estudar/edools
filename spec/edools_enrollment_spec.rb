# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::Enrollment do
    let(:enrollment) { Edools::Enrollment.create registration_id: '6479697',
                  school_product_id: '73636',
                  max_attendance_type: "indeterminate"
    }

  describe '.all' do
    context 'pass the raw parameter as false' do
      it 'returns without raw data' do
        VCR.use_cassette('enrollment/all_with_raw_as_false') do
          result = Edools::Enrollment.all

          expect(result.count).to be 10
        end
      end
    end

    context 'pass the raw parameter as true' do
      it 'returns with raw data' do
        VCR.use_cassette('enrollment/all_with_raw_as_true') do
          result = Edools::Enrollment.all({school_product:{id: 73636}, student_id: 6506727}, true)

          expect(result[:enrollments].count).to be 4
        end
      end
    end
  end

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

  describe '.lessons_progresses' do
    context 'when valid params' do
      it 'succeeds' do
        VCR.use_cassette('enrollment/lessons_progresses_valid') do
          result = Edools::Enrollment.lessons_progresses({id: 2022188})

          expect(result[:lessons_progresses].map{|o| o[:progress] }.compact.uniq.first).to be 100.0
          expect(result[:lessons_progresses].map{|o| o[:completed] }.compact.uniq.first).to be true
        end
      end

      it 'must have 10 per page' do
        VCR.use_cassette('enrollment/lessons_progresses_valid') do
          result = Edools::Enrollment.lessons_progresses({id: 2022188})

          expect(result[:lessons_progresses].count).to be 10
          expect(result[:per_page]).to be 10
          expect(result[:current_page]).to be 1
          expect(result[:total_pages]).to be 3
          expect(result[:total_count]).to be 30
        end
      end

      it 'succeeds with pass per_page' do
        VCR.use_cassette('enrollment/lessons_progresses_valid_pass_per_page') do
          result = Edools::Enrollment.lessons_progresses({id: 2022188, per_page: 40})

          expect(result[:lessons_progresses].count).to be 30
          expect(result[:per_page]).to be 40
          expect(result[:current_page]).to be 1
          expect(result[:total_pages]).to be 1
          expect(result[:total_count]).to be 30
        end
      end

      it 'succeeds with pass current page' do
        VCR.use_cassette('enrollment/lessons_progresses_valid_pass_current_page') do
          result = Edools::Enrollment.lessons_progresses({id: 2022188, page: 3})

          expect(result[:lessons_progresses].count).to be 10
          expect(result[:per_page]).to be 10
          expect(result[:current_page]).to be 3
          expect(result[:total_pages]).to be 3
          expect(result[:total_count]).to be 30
        end
      end
    end

    context 'when lessons_progresses doesn\'t exist' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('enrollment/lessons_progresses_not_found') do
          expect { Edools::Enrollment.lessons_progresses id: 'test' }.to raise_error Edools::NotFound
        end
      end
    end

    context 'when without params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('enrollment/lessons_progresses_without_params') do
          expect { Edools::Enrollment.lessons_progresses }.to raise_error ArgumentError
        end
      end
    end
  end
end
