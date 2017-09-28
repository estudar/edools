# frozen_string_literal: true

module Edools
  class SchoolProduct
    attr_reader :id, :title, :description, :subtitle, :logo, :errors

    def initialize(data = {})
      @id = data[:id]
      @title = data[:title]
      @description = data[:description]
      @subtitle = data[:subtitle]
      @logo = data[:logo]
      @errors = data[:errors]
    end

    def self.create(data = {})
      raise ArgumentError, 'missing school id' unless data.key? :school_id

      url = "#{Edools.base_url}/schools/#{data[:school_id]}/school_products"
      new Edools::ApiRequest.request(:post, url, school_product: data)
    rescue Edools::RequestWithErrors => exception
      new exception.errors
    end

    def self.all
      url = "#{Edools.base_url}/school_products"
      response = Edools::ApiRequest.request(:get, url)
      response[:school_products].map { |school_product| new school_product }
    end
  end
end
