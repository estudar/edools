# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::ApiRequest do
  describe '.headers' do
    let(:headers) { Edools::ApiRequest.headers }

    it 'has all required headers' do
      expect(headers).to include :accept, :authorization
    end
  end

  describe '.build_request' do
    let(:build_request) { Edools::ApiRequest.build_request(:post, 'https://google.com', {}) }

    it 'has all required keys' do
      expect(build_request).to include :headers, :method, :payload, :url, :timeout, :verify_ssl
    end

    it 'is multipart' do
      expect(build_request.fetch(:payload)).to include multipart: true
    end
  end
end
