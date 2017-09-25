# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools do
  it 'has a version number' do
    expect(Edools::VERSION).not_to be nil
  end

  it 'sets the api_token' do
    Edools.api_token = '1234'

    expect(Edools.api_token).to eq '1234'
  end

  it 'has a base_url' do
    expect(Edools.base_url).to eq 'https://core.myedools.info'
  end
end
