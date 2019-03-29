# frozen_string_literal: true

module Edools
  class ExamAnswer
    attr_reader :exam_answer, :errors
    attr_accessor :paginate

    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 50

    def initialize(data = {})
      @exam_answer = self.class.objectify_exam_answer(data)
      @errors = data.fetch(:errors, nil)
    end

    def self.show(data = {})
      raise ArgumentError, 'missing id' unless data.key? :id

      url = "#{base_url}/#{data[:id]}"


      exam_answer = Edools::ApiRequest.request(:get, url, data)

      new exam_answer
    end

    def self.base_url
      "#{Edools.base_url}/exam_answers"
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

    def self.objectify_exam_answer(exam_answer)
      return exam_answer if exam_answer.nil?
      OpenStruct.new(
        id: exam_answer.fetch(:id, nil),
        lesson_progress_id: exam_answer.fetch(:lesson_progress_id, nil),
        activity_id: exam_answer.fetch(:activity_id, nil),
        collaborator_id: exam_answer.fetch(:collaborator_id, nil),
        auto_corrected: exam_answer.fetch(:auto_corrected, nil),
        score: exam_answer.fetch(:score, nil),
        comment: exam_answer.fetch(:comment, nil),
        s3_files: exam_answer.fetch(:s3_files, nil),
        student: objectify_student(exam_answer.fetch(:student, nil)),
        exam_question_answers: objectify_exam_question_answers(exam_answer.fetch(:exam_question_answers, nil)),
        corrected_at: exam_answer.fetch(:corrected_at, nil),
        created_at: exam_answer.fetch(:created_at, nil),
        updated_at: exam_answer.fetch(:updated_at, nil)
      )
    rescue NoMethodError => error
      Edools.logger.error(error)
    end

    def self.objectify_student(student = nil)
      return student if student.nil?
      OpenStruct.new(
        id: student.fetch(:id, nil),
        first_name: student.fetch(:first_name, nil),
        last_name: student.fetch(:last_name, nil),
        cover_image_url: student.fetch(:cover_image_url, nil)
      )
    rescue NoMethodError => error
      Edools.logger.error(error)
    end

    def self.objectify_exam_question_answers(exam_question_answers)
      exam_question_answers.map do |exam_question_answer|
        objectify_exam_question_answer(exam_question_answer)
      end.compact
    end

    def self.objectify_exam_question_answer(exam_question_answer = nil)
      return exam_question_answer if exam_question_answer.nil?
      OpenStruct.new(
        id: exam_question_answer.fetch(:id, nil),
        exam_question: objectify_exam_question(exam_question_answer.fetch(:exam_question, nil)),
        score: exam_question_answer.fetch(:score, nil),
        correct: exam_question_answer.fetch(:correct, nil),
        multiple_choice_option_id: exam_question_answer.fetch(:multiple_choice_option_id, nil),
        text: exam_question_answer.fetch(:text, nil),
        comment: exam_question_answer.fetch(:comment, nil),
        associative_options: exam_question_answer.fetch(:associative_options, nil)
      )
    rescue NoMethodError => error
      Edools.logger.error(error)
    end

    def self.objectify_exam_question(exam_question = nil)
      return exam_question if exam_question.nil?
      OpenStruct.new(
        id: exam_question.fetch(:id, nil),
        order: exam_question.fetch(:order, nil),
        point: exam_question.fetch(:point, nil),
        type: exam_question.fetch(:type, nil),
        title: exam_question.fetch(:title, nil),
        library_resources: objectify_library_resources(exam_question.fetch(:library_resources, nil)),
        comment: exam_question.fetch(:comment, nil)
      )
    rescue NoMethodError => error
      Edools.logger.error(error)
    end

    def self.objectify_library_resources(library_resources)
      library_resources.map do |library_resource|
        objectify_library_resource(library_resource)
      end.compact
    end

    def self.objectify_library_resource(library_resource = nil)
      return library_resource if library_resource.nil?
      OpenStruct.new(
        id: library_resource.fetch(:id, nil),
        title: library_resource.fetch(:title, nil),
        correct: library_resource.fetch(:correct, nil)
      )
    rescue NoMethodError => error
      Edools.logger.error(error)
    end
  end
end
