# frozen_string_literal: true

module Edools
  class Course
    attr_reader :id, :name, :description, :duration, :code, :ready, :course_modules_ids, :errors

    def initialize(data = {})
      @id = data[:id]
      @name = data[:name]
      @description = data[:description]
      @duration = data[:duration]
      @code = data[:code]
      @ready = data[:ready]
      @course_module_ids = data[:course_modules_ids]
      @errors = data[:errors]
    end

    def self.create(data = {})
      new Edools::ApiRequest.request(:post, base_url, course: data)
    rescue Edools::RequestWithErrors => exception
      new exception.errors
    end

    # TODO: Paginate
    def self.all
      response = Edools::ApiRequest.request(:get, base_url)
      response[:courses].map { |course| new course }
    end

    def self.base_url
      "#{Edools.base_url}/courses"
    end
  end
end
