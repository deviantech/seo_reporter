# Here down: kiba kiba/page_report.rb

require 'kiba-common/sources/enumerable'
require 'kiba-common/destinations/csv'
require 'kiba-common/dsl_extensions/show_me'

require 'kiba/parse_url_and_text'
require 'kiba/phrase_count_from_text'

module SeoReporter
  module Reports
    module_function

    def setup(source_file, sequel_connection, logger)
      Kiba.parse do
        pre_process do
          logger.info "Starting processing for file #{source_file}"
        end

        source CSVSource,
          filename: source_file,
          csv_options: { headers: true, col_sep: ',' }

        # SNIP

        destination Kiba::Pro::Destination::SQLUpsert,
          table: :partners,
          unique_key: :crm_partner_id,
          database: sequel_connection
      end
    end
  end
end

job = ETL::SyncPartners.setup(my_source_file, my_sequel_connection, logger)
Kiba.run(job)

extend Kiba::Common::DSLExtensions::ShowMe

SITE = ENV.fetch('SITE')

PHRASES = ['bamboo sunglasses', 'panda sunglasses', 'bamboo']

pre_process do
  unless File.exists?( Site::Pages.new(site: SITE).cache_file )
    raise "No local site data cache at #{Site::Pages.new.cache_file} -- cannot continue until Reporter.refresh_cache has been executed"
  end
end


source Kiba::Common::Sources::Enumerable, -> { Site::Pages.new.all_pages }

transform ParseUrlAndText
transform PhraseCountFromText, PHRASES

@phrase_counts ||= make_hash(0)
@phrase_sources ||= make_hash([])

transform do |row|
  row[:phrase_counts].each do |phrase, count_at_url|
    @phrase_sources[phrase] << row[:url]
    @phrase_counts[phrase] += count_at_url
  end

  row
end


# show_me!
# destination Kiba::Common::Destinations::CSV, filename: KIBA_REPORT
