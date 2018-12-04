# frozen_string_literal: true

require 'edools/version'
require 'edools/utils'
require 'edools/api_request'
require 'edools/school'
require 'edools/course'
require 'edools/school_product'
require 'edools/invitation'
require 'edools/user'
require 'edools/session'
require 'edools/media'
require 'edools/enrollment'
require 'pry'

module Edools
  class RequestFailed < StandardError
  end

  class BadRequest < StandardError
  end

  class NotFound < StandardError
  end

  class Unauthorized < StandardError
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
    attr_accessor :api_token, :school_api_url
    attr_reader :api_version
  end

  @api_version = 'v1'

  def self.base_url
    self.school_api_url || 'https://core.myedools.com'
  end
end
