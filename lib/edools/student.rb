# frozen_string_literal: true

module Edools
  class Student
    attr_reader :id, :first_name, :email, :errors

    def initialize(data = {})
      @id = data[:id]
      @first_name = data[:first_name]
      @email = data[:email]
      @errors = data[:errors]
    end

    def self.all(data = {})
      response = Edools::ApiRequest.request(:get, base_url, data)
      response[:students].map { |student| new student }
    end

    def self.base_url
      "#{Edools.base_url}/students"
    end
  end
end
