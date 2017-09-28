# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::Student do
  let(:school) { Edools::School.create name: 'Test', email: 'test@test.com', password: '12345678' }

  describe '.all' do
    let(:all) { Edools::Student.all }

    it 'returns an array' do
      preserving_environment do
        school.set_as_global_environment
        expect(all).to be_instance_of Array
      end
    end
  end
end
