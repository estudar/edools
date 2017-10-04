# frozen_string_literal: true

module Edools
  class Utils
    def self.api_token_from_env
      Edools.api_token = ENV['EDOOLS_API_TOKEN']
    end

    def self.csv_to_hash(csv)
      csv.gsub!(/(^;)|(;$)/, '')
      entries = CSV.parse(csv, col_sep: ';', headers: true, header_converters: :symbol, skip_blanks: true)

      entries.map(&:to_hash)
    end
  end
end
