# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::LessonProgress do
  describe '.find_paginated_by_enrollment' do
    context 'when valid params' do
      it 'succeeds' do
        VCR.use_cassette('lesson_progress/all_from_enrollments_succeeds') do
          result = Edools::LessonProgress.find_paginated_by_enrollment(enrollment_id: 2075731)

          expect(result.count).to be 31
        end
      end
    end

    context 'when enrollment doesn\'t exist' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('lesson_progress/all_from_enrollments_not_found') do
          expect { Edools::LessonProgress.find_paginated_by_enrollment(enrollment_id: 'test') }.to raise_error Edools::NotFound
        end
      end
    end

    context 'when without params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('enrollment/all_from_enrollments_without_params') do
          expect { Edools::LessonProgress.find_paginated_by_enrollment }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '.find_paginated_by_student' do
    context 'when valid params' do
      it 'succeeds' do
        VCR.use_cassette('lesson_progress/all_from_students_succeeds') do
          result = Edools::LessonProgress.find_paginated_by_student(student_id: 6558938)

          expect(result.count).to be 30
        end
      end
    end

    context 'when enrollment doesn\'t exist' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('lesson_progress/all_from_students_not_found') do
          expect { Edools::LessonProgress.find_paginated_by_student(student_id: 'test') }.to raise_error Edools::NotFound
        end
      end
    end

    context 'when without params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('enrollment/all_from_students_without_params') do
          expect { Edools::LessonProgress.find_paginated_by_student }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '.find_paginated_by_school_product' do
    context 'when valid params' do
      it 'succeeds' do
        VCR.use_cassette('lesson_progress/all_from_school_products_succeeds') do
          result = Edools::LessonProgress.find_paginated_by_school_product(school_product_id: 73636)

          expect(result.count).to be 50
          expect(result.paginate.total_pages).to be 1526
          expect(result.paginate.total_count).to be 76254
        end
      end
    end

    context 'when enrollment doesn\'t exist' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('lesson_progress/all_from_school_products_not_found') do
          expect { Edools::LessonProgress.find_paginated_by_school_product(school_product_id: 'test') }.to raise_error Edools::NotFound
        end
      end
    end

    context 'when without params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('enrollment/all_from_school_products_without_params') do
          expect { Edools::LessonProgress.find_paginated_by_school_product }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '.create' do
    context 'when valid params' do
      it 'succeeds' do
        VCR.use_cassette('lesson_progress/create_valid') do
          data = {
            enrollment_id: 2119734,
            lesson_progress: {
              lesson_id: 1161016,
              completed: true,
              progress: 100.0
            }
          }

          result = Edools::LessonProgress.create(data)
          expect(result.completed).to be true
        end
      end
    end

    context 'when enrollment doesn\'t exist' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('lesson_progress/create_not_found') do
          data = {
            enrollment_id: 'test',
            lesson_progress: {
              lesson_id: 1161016,
              completed: true,
              progress: 100.0
            }
          }

          expect { Edools::LessonProgress.create(data) }.to raise_error Edools::NotFound
        end
      end
    end

    context 'when without params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('lesson_progress/create_without_params') do
          expect { Edools::LessonProgress.create }.to raise_error ArgumentError
        end
      end
    end
  end
end
