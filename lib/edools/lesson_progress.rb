# frozen_string_literal: true

module Edools
  class LessonProgress
    attr_reader :lesson_progress, :errors
    attr_accessor :paginate

    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 50

    def initialize(data = {})
      @lesson_progress = self.class.objectify_lesson_progress(data)
      @errors = data.fetch(:errors, nil)
    end

    def self.find_paginated_by_enrollment(enrollment_id: , page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
      raise ArgumentError, 'missing enrollment_id' if enrollment_id.nil?

      url = "#{base_url_enrollments}/#{enrollment_id}/lessons_progresses"
      data = { enrollment_id: enrollment_id, page: page, per_page: per_page }

      response = Edools::ApiRequest.request(:get, url, data)

      Edools::PaginationProxy.new(objectify_lessons_progresses(response[:lessons_progresses])).tap do |proxy|
        proxy.paginate = objectify_paginate(response)
      end
    end

    def self.find_paginated_by_student(student_id: , page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
      raise ArgumentError, 'missing student_id' if student_id.nil?

      url = "#{base_url_students}/#{student_id}/lessons_progresses"
      data = { student_id: student_id, page: page, per_page: per_page }

      response = Edools::ApiRequest.request(:get, url, data)

      Edools::PaginationProxy.new(objectify_lessons_progresses(response[:lessons_progresses])).tap do |proxy|
        proxy.paginate = objectify_paginate(response)
      end
    end

    def self.find_paginated_by_school_product(school_product_id: , page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
      raise ArgumentError, 'missing school_product_id' if school_product_id.nil?

      url = "#{base_url_school_products}/#{school_product_id}/lessons_progresses"
      data = { school_product_id: school_product_id, page: page, per_page: per_page }

      response = Edools::ApiRequest.request(:get, url, data)

      Edools::PaginationProxy.new(objectify_lessons_progresses(response[:lessons_progresses])).tap do |proxy|
        proxy.paginate = objectify_paginate(response)
      end
    end

    def self.show(data = {})
      raise ArgumentError, 'missing id' unless data.key? :id

      response = Edools::ApiRequest.request(:get, base_url, data)

      response[:lessons_progresses].map do |lesson_progress|
        new lesson_progress
      end
    end

    def self.create(data = {})
      raise ArgumentError, 'missing enrollment_id' unless data.key? :enrollment_id
      raise ArgumentError, 'missing course_id' unless data.key? :course_id
      raise ArgumentError, 'missing lesson_progress' unless data.key? :lesson_progress

      url = "#{base_url_enrollments}/#{data[:enrollment_id]}/lessons_progresses"

      response = Edools::ApiRequest.request(:post, url, data)
      objectify_lesson_progress(response)

    rescue Edools::RequestWithErrors => exception
      Edools.logger.error("#{exception.message}: #{exception.errors}")
      new exception.errors
    end

    def self.base_url_enrollments
      "#{Edools.base_url}/enrollments"
    end

    def self.base_url_students
      "#{Edools.base_url}/students"
    end

    def self.base_url_school_products
      "#{Edools.base_url}/school_products"
    end

    def self.base_url
      "#{Edools.base_url}/lessons_progresses"
    end

    private

    def self.objectify_paginate(paginate)
      return paginate if paginate.nil?
      OpenStruct.new(
        current_page: paginate.fetch(:current_page, nil),
        per_page: paginate.fetch(:per_page, nil),
        total_pages: paginate.fetch(:total_pages, nil),
        total_count: paginate.fetch(:total_count, nil)
      )
    rescue NoMethodError => error
      Edools.logger.error(error)
    end

    def self.objectify_lessons_progresses(lessons_progresses)
      lessons_progresses.map do |lesson_progress|
        objectify_lesson_progress(lesson_progress)
      end.compact
    end

    def self.objectify_lesson_progress(lesson_progress)
      return lesson_progress if lesson_progress.nil?
      OpenStruct.new(
        id: lesson_progress.fetch(:id, nil),
        progress: lesson_progress.fetch(:progress, nil),
        completed: lesson_progress.fetch(:completed, nil),
        grade: lesson_progress.fetch(:grade, nil),
        enrollment_id: lesson_progress.fetch(:enrollment_id, nil),
        exam_answer_ids: lesson_progress.fetch(:exam_answer_ids, nil),
        time_spent: lesson_progress.fetch(:time_spent, nil),
        views: lesson_progress.fetch(:views, nil),
        current_video_time: lesson_progress.fetch(:current_video_time, nil),
        lesson: objectify_lesson(lesson_progress.fetch(:lesson, nil)),
        lesson_id: lesson_progress.fetch(:lesson_id, nil),
        school_id: lesson_progress.fetch(:school_id, nil),
        progress_card: objectify_progress_card(lesson_progress.fetch(:progress_card, nil)),
        progress_card_id: lesson_progress.fetch(:progress_card_id, nil),
        enrollment: objectify_enrollment(lesson_progress.fetch(:enrollment, nil)),
        external_id: lesson_progress.fetch(:external_id, nil),
        last_view_at: lesson_progress.fetch(:last_view_at, nil),
        created_at: lesson_progress.fetch(:created_at, nil),
        updated_at: lesson_progress.fetch(:updated_at, nil)
      )
    rescue NoMethodError => error
      Edools.logger.error(error)
    end

    def self.objectify_lesson(lesson = nil)
      return lesson if lesson.nil?
      OpenStruct.new(
        id: lesson.fetch(:id, nil),
        type: lesson.fetch(:type, nil),
        title: lesson.fetch(:title, nil)
      )
    end

    def self.objectify_progress_card(progress_card = nil)
      return progress_card if progress_card.nil?
      OpenStruct.new(
        course_name: progress_card.fetch(:course, {}).fetch(:name, nil)
      )
    end

    def self.objectify_enrollment(enrollment = nil)
      return enrollment if enrollment.nil?
      OpenStruct.new(
        id: enrollment.fetch(:id, nil),
        student_first_name: enrollment.fetch(:student, {}).fetch(:first_name, nil),
        student_last_name: enrollment.fetch(:student, {}).fetch(:last_name, nil),
        student_cover_image_url: enrollment.fetch(:student, {}).fetch(:cover_image_url, nil)
      )
    end
  end
end
