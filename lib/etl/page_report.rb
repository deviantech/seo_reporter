# Here down: kiba kiba/page_report.rb

require 'kiba-common/sources/enumerable'
require 'kiba-common/destinations/csv'
require 'kiba-common/dsl_extensions/show_me'

module ETL
  module PageReport

    module_function

    def per_page(url, csv_out: nil, with_transform:)
      site = Site::Pages.new(site: url)
      Kiba.parse do
        extend Kiba::DSLExtensions::Config
        config :kiba, runner: Kiba::StreamingRunner

        pre_process do
          unless File.exists?( site.cache_file )
            raise "No local site data cache at #{site.cache_file} -- aborting"
          end
        end

        source Kiba::Common::Sources::Enumerable, -> { site.all_pages }

        transform with_transform

        if csv_out
          # Elegant would get max idx. This'll do -- increase the upto num until it doesn't error
          @blank_row = 1.upto(200).each_with_object({}) do |n, hash|
            hash["header_#{n}".to_sym] = nil
          end

          transform do |row|
            @blank_row.merge(row)
          end

          destination Kiba::Common::Destinations::CSV, filename: csv_out
        else
          extend Kiba::Common::DSLExtensions::ShowMe
          show_me!
        end

        post_process do
          puts("Wrote to #{csv_out}") if csv_out
        end

      end
    end
  end
end
