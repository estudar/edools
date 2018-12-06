# frozen_string_literal: true

module Edools
  class LessonProgress
    attr_reader :lesson_progress, :errors
    attr_accessor :paginate

    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 50

    def initialize(data = {})
      @lesson_progress = objectify_lesson_progress(data)
      @errors = data.dig(:errors)
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
      raise ArgumentError, 'missing lesson_progress' unless data.key? :lesson_progress

      url = "#{base_url_enrollments}/#{data[:enrollment_id]}/lessons_progresses"
      response = Edools::ApiRequest.request(:post, url, data)

      objectify_lesson_progress(response)
    rescue Edools::RequestWithErrors => exception
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
        current_page: paginate.dig(:current_page),
        per_page: paginate.dig(:per_page),
        total_pages: paginate.dig(:total_pages),
        total_count: paginate.dig(:total_count)
      )
    rescue NoMethodError => error
      puts Edools.logger.error(error)
    end

    def self.objectify_lessons_progresses(lessons_progresses)
      lessons_progresses.map do |lesson_progress|
        objectify_lesson_progress(lesson_progress)
      end.compact
    end

    def self.objectify_lesson_progress(lesson_progress)
      return lesson_progress if lesson_progress.nil?
      OpenStruct.new(
        id: lesson_progress.dig(:id),
        progress: lesson_progress.dig(:progress),
        completed: lesson_progress.dig(:completed),
        grade: lesson_progress.dig(:grade),
        enrollment_id: lesson_progress.dig(:enrollment_id),
        exam_answer_ids: lesson_progress.dig(:exam_answer_ids),
        time_spent: lesson_progress.dig(:time_spent),
        views: lesson_progress.dig(:views),
        current_video_time: lesson_progress.dig(:current_video_time),
        lesson: objectify_lesson(lesson_progress.dig(:lesson)),
        lesson_id: lesson_progress.dig(:lesson_id),
        school_id: lesson_progress.dig(:school_id),
        progress_card: objectify_progress_card(lesson_progress.dig(:progress_card)),
        progress_card_id: lesson_progress.dig(:progress_card_id),
        enrollment: objectify_enrollment(lesson_progress.dig(:enrollment)),
        external_id: lesson_progress.dig(:external_id),
        last_view_at: lesson_progress.dig(:last_view_at),
        created_at: lesson_progress.dig(:created_at),
        updated_at: lesson_progress.dig(:updated_at)
      )
    rescue NoMethodError => error
      puts Edools.logger.error(error)
    end

    def self.objectify_lesson(lesson = nil)
      return lesson if lesson.nil?
      OpenStruct.new(
        id: lesson.dig(:id),
        type: lesson.dig(:type),
        title: lesson.dig(:title)
      )
    end

    def self.objectify_progress_card(progress_card = nil)
      return progress_card if progress_card.nil?
      OpenStruct.new(
        course_name: progress_card.dig(:course, :name)
      )
    end

    def self.objectify_enrollment(enrollment = nil)
      return enrollment if enrollment.nil?
      OpenStruct.new(
        id: enrollment.dig(:id),
        student_first_name: enrollment.dig(:student, :first_name),
        student_last_name: enrollment.dig(:student, :last_name),
        student_cover_image_url: enrollment.dig(:student, :cover_image_url)
      )
    end
  end
end
