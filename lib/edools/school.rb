# frozen_string_literal: true

module Edools
  class School
    attr_reader :id, :name, :subdomain, :credentials, :errors

    def initialize(data = {})
      @id = data.fetch(:school, {}).fetch(:id, nil)
      @name = data.fetch(:school, {}).fetch(:name, nil)
      @subdomain = data.fetch(:school, {}).fetch(:subdomain, nil)
      @credentials = data.fetch(:admin, {}).fetch(:credentials, nil)
      @errors = data[:errors]
    end

    def self.create(data = {})
      url = "#{base_url}/wizard"
      new Edools::ApiRequest.request(:post, url, school: data)
    rescue RequestWithErrors => exception
      new exception.errors
    end

    def self.update(data = {})
      raise ArgumentError, 'missing id' unless data.key? :id

      url = "#{base_url}/#{data[:id]}"
      Edools::ApiRequest.request(:patch, url, school: data)
    end

    def self.base_url
      "#{Edools.base_url}/schools"
    end

    def set_as_global_environment
      return false if credentials.nil?

      Edools.api_token = credentials
      true
    end
  end
end
