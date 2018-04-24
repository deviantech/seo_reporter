# Here down: kiba kiba/report.rb

require 'kiba-common/sources/enumerable'
require 'kiba-common/destinations/csv'
require 'kiba-common/dsl_extensions/show_me'

require 'kiba/parse_url_and_text'
require 'kiba/phrase_count_from_text'

extend Kiba::Common::DSLExtensions::ShowMe

PHRASES = ['bamboo sunglasses', 'panda sunglasses', 'bamboo']

raise "Not quite completed - made it work without kiba, haven't bothered converting kiba version yet [see SeoReporter.keyword_report(write: true)"

pre_process do
  unless File.exists?( Site::Pages.new.cache_file )
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
