# frozen_string_literal: true

require 'rest-client'
require 'csv'

module Edools
  class Media
    attr_reader :id, :title, :s3_file_url

    def initialize(data = {})
      @id = data[:id]
      @title = data[:title]
      @s3_file_url = data[:s3_file_url]
    end

    def self.find(id)
      url = "#{base_url}/#{id}"
      new Edools::ApiRequest.request(:get, url)
    end

    def self.base_url
      "#{Edools.base_url}/media"
    end

    def s3_file_content
      response = RestClient.get(s3_file_url)
      response.body
    end
  end
end
