# frozen_string_literal: true

require 'rest-client'
require 'json'

module Edools
  class ApiRequest
    def self.request(method, url, data = {})
      Edools::Utils.api_token_from_env if Edools.api_token.nil?
      handle_response RestClient::Request.execute(build_request(method, url, data))
    rescue RestClient::BadRequest, RestClient::UnprocessableEntity => exception
      raise RequestWithErrors, JSON.parse(exception.response, symbolize_names: true)
    end

    def self.handle_response(response)
      JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError
      raise RequestFailed
    end

    def self.build_request(method, url, data)
      {
        headers: headers,
        method: method,
        payload: data.merge(multipart: true),
        timeout: 30,
        url: url,
        verify_ssl: true
      }
    end

    def self.headers
      {
        accept: "application/vnd.edools.core.#{Edools.api_version}+json",
        authorization: "Token token=\"#{Edools.api_token}\""
      }
    end
  end
end
