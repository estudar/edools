# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Edools::ExamAnswer do
  describe '.show' do
    context 'when send valid params' do
      it 'raises Edools::NotFound' do
        VCR.use_cassette('exam_answer/show_not_found') do
          expect { Edools::ExamAnswer.show(id: 'test') }.to raise_error Edools::NotFound
        end
      end

      it 'succeeds' do
        VCR.use_cassette('exam_answer/show_succeeds') do
          result = Edools::ExamAnswer.show(id: 1196779)

          expect(result.exam_answer[:id]).to be 1196779
        end
      end
    end

    context 'when send nothing' do
      it 'raises ArgumentError' do
        VCR.use_cassette('exam_answer/show_without_params') do
          expect { Edools::ExamAnswer.show }.to raise_error ArgumentError
        end
      end
    end

    context 'when send invalid params' do
      it 'raises ArgumentError' do
        VCR.use_cassette('exam_answer/show_with_invalid_params') do
          expect { Edools::ExamAnswer.show(a: 'a') }.to raise_error ArgumentError
        end
      end
    end
  end
end
