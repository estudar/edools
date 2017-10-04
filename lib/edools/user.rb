# frozen_string_literal: true

module Edools
  class User
    attr_reader :id, :first_name, :email, :type, :registrations, :errors

    def initialize(data = {})
      @id = data[:id]
      @first_name = data[:first_name]
      @email = data[:email]
      @type = data[:type]
      @registrations = data[:registrations]
      @errors = data[:errors]
    end

    def self.create(data = {})
      raise ArgumentError, 'missing user type' unless data.key? :type

      is_student = data[:type].casecmp('student').zero?
      url = is_student ? student_base_url : collaborator_base_url
      new Edools::ApiRequest.request(:post, url, user: data)
    rescue Edools::RequestWithErrors => exception
      new exception.errors
    end

    def self.all(data = {})
      raise ArgumentError, 'missing user type' unless data.key? :type

      is_student = data[:type].casecmp('student').zero?
      url = is_student ? student_base_url : collaborator_base_url
      response = Edools::ApiRequest.request(:get, url, data)
      response[:"#{is_student ? 'students' : 'collaborators'}"].map { |user| new user }
    end

    def self.find(data = {})
      raise ArgumentError, 'missing user type' unless data.key? :type
      raise ArgumentError, 'missing user id' unless data.key? :id

      is_student = data[:type].casecmp('student').zero?
      url = is_student ? student_base_url : collaborator_base_url
      new Edools::ApiRequest.request(:get, "#{url}/#{data[:id]}")
    end

    def self.student_base_url
      "#{Edools.base_url}/students"
    end

    def self.collaborator_base_url
      "#{Edools.base_url}/collaborators"
    end

    def self.create_from_csv(csv)
      entries = Utils.csv_to_hash(csv)

      entries.map do |entry|
        user = find_or_create(entry)
        next if user.type == 'Collaborator' || entry[:school_product_id] == '0'
        user.enroll(entry[:school_product_id])
      end

      true
    end

    def self.find_or_create(data)
      raise ArgumentError, 'missing user email' unless data.key? :email

      user = all(type: data[:type], full_name: data[:email]).first
      user || create(data.merge(password: '123456', password_confirmation: '123456'))
    end

    def enroll(school_product_id)
      Enrollment.find_or_create(student_id: id, school_product_id: school_product_id)
    end
  end
end
