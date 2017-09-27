# frozen_string_literal: true

require 'dotenv/load'
require 'edools/version'
require 'edools/utils'
require 'edools/api_request'
require 'edools/school'
require 'edools/course'
require 'edools/school_product'

module Edools
  class RequestFailed < StandardError
  end

  class BadRequest < StandardError
  end

  class NotFound < StandardError
  end

  class AuthenticationException < StandardError
  end

  class RequestWithErrors < StandardError
    attr_accessor :errors

    def initialize(errors)
      @errors = errors
    end
  end

  class << self
    attr_accessor :api_token
    attr_reader :api_version
  end

  @api_version = 'v1'

  def self.base_url
    'https://core.myedools.info'
  end
end
