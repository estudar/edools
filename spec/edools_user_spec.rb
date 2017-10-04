# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::User do
  let(:school) { Edools::School.create name: 'Test', email: 'test@test.com', password: '12345678' }

  describe '.all' do
    let(:all) { Edools::User.all type: 'student' }

    it 'returns an array' do
      VCR.use_cassette('user/all') do
        preserving_environment do
          school.set_as_global_environment
          expect(all).to be_instance_of Array
        end
      end
    end
  end
end
