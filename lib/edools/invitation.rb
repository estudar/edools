# frozen_string_literal: true

module Edools
  class Invitation
    attr_reader :id, :first_name, :email, :errors

    def initialize(data = {})
      @id = data[:id]
      @first_name = data[:first_name]
      @email = data[:email]
      @errors = data[:errors]
    end

    def self.create(data = {})
      new Edools::ApiRequest.request(:post, base_url, invitation: data)
    rescue Edools::RequestWithErrors => exception
      new exception.errors
    end

    def self.base_url
      "#{Edools.base_url}/invitations"
    end
  end
end
