# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::SchoolProduct do
  let(:school) { Edools::School.create name: 'Test', email: 'test@test.com', password: '12345678' }
  let(:school_product) { Edools::SchoolProduct.create title: 'Test', school_id: school.id }

  describe '.create' do
    context 'when valid params' do
      it 'returns an instance of Edools::SchoolProduct' do
        preserving_environment do
          school.set_as_global_environment
          expect(school_product).to be_an_instance_of Edools::SchoolProduct
        end
      end
    end

    context 'when invalid params' do
      let(:school_product) { Edools::SchoolProduct.create foo: '1', school_id: school.id }

      it 'returns an instance of Edools::SchoolProduct' do
        preserving_environment do
          school.set_as_global_environment
          expect(school_product).to be_an_instance_of Edools::SchoolProduct
        end
      end

      it 'has errors' do
        preserving_environment do
          school.set_as_global_environment
          expect(school_product.errors).not_to be_empty
        end
      end
    end

    context 'when without params' do
      let(:school_product) { Edools::SchoolProduct.create }

      it 'raises Edools::BadRequest' do
        preserving_environment do
          school.set_as_global_environment
          expect { school_product }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '.all' do
    let(:all) { Edools::SchoolProduct.all }

    it 'returns an array' do
      preserving_environment do
        school.set_as_global_environment
        expect(all).to be_instance_of Array
      end
    end
  end
end
