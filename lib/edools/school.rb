# frozen_string_literal: true

module Edools
  class School
    attr_reader :id, :name, :subdomain, :credentials, :errors

    def initialize(data = {})
      @id = data.dig :school, :id
      @name = data.dig :school, :name
      @subdomain = data.dig :school, :subdomain
      @credentials = data.dig :admin, :credentials
      @errors = data[:errors]
    end

    def self.create(data = {})
      url = "#{base_url}/wizard"
      new Edools::ApiRequest.request(:post, url, school: data)
    rescue Edools::RequestWithErrors => exception
      new exception.errors
    end

    def self.update
      # TODO
    end

    def self.base_url
      "#{Edools.base_url}/schools"
    end

    def set_as_global_environment
      return false if subdomain.nil? || credentials.nil?

      Edools.subdomain = subdomain
      Edools.api_token = credentials
    end
  end
end
