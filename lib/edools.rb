# frozen_string_literal: true

require 'edools/version'

module Edools
  class << self
    attr_accessor :api_token
  end

  def self.base_uri
    'https://core.myedools.info/'
  end
end
