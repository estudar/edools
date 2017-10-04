# frozen_string_literal: true

module Edools
  class Enrollment
    attr_reader :id, :first_name, :email, :type, :errors

    def initialize(data = {})
      @id = data[:id]
      @first_name = data[:first_name]
      @email = data[:email]
      @type = data[:type]
      @errors = data[:errors]
    end

    def self.create(data = {})
      new Edools::ApiRequest.request(:post, base_url, enrollment: data)
    rescue Edools::RequestWithErrors => exception
      new exception.errors
    end

    def self.all(data = {})
      response = Edools::ApiRequest.request(:get, base_url, data)
      response[:enrollments].map { |enrollment| new enrollment }
    end

    def self.base_url
      "#{Edools.base_url}/enrollments"
    end

    def self.find_or_create(data = {})
      raise ArgumentError, 'missing school_product_id' unless data.key? :school_product_id
      raise ArgumentError, 'missing student_id' unless data.key? :student_id

      enrollments = all(data)
      return enrollments.first if enrollments.any?

      student = User.find(type: 'student', id: data[:student_id])
      create(data.merge(max_attendance_type: 'indeterminate', registration_id: student.registrations.first[:id]))
    end
  end
end
