#!/usr/bin/env ruby
#
# Report(s) on SEO.

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require(:default)

require 'csv'


KIBA_REPORT = 'data/seo/kiba.csv'
KEYWORD_REPORT_IN = 'data/seo/keywords.csv'
KEYWORD_REPORT_OUT = 'data/seo/keywords-report.csv'





# Reporter.page_report
# Reporter.keyword_report(write: true)
# Reporter.top_words

# Here down: kiba bin/scripts/seo_report.rb
# https://github.com/thbar/kiba-common
# require 'kiba-common/sources/enumerable'
# require 'kiba-common/dsl_extensions/show_me'
# require 'kiba-common/destinations/csv'

# extend Kiba::Common::DSLExtensions::ShowMe

# PHRASES = ['bamboo sunglasses', 'panda sunglasses', 'bamboo']

# class ParseSitePageData
#   def process(page)
#     return unless page.html.present?
#     return unless (text = parsed_text(page)).present?

#     {
#       url: page.url,
#       text: text,
#     }
#   end

#   private

#   def parsed_text(page)
#     Nokogiri::HTML(page.html).at('body')&.text&.downcase
#   end
# end

# class PhraseCountFromRawText
#   attr_reader :phrases
#   def initialize(phrases)
#     @phrases = phrases.map(&:downcase)
#   end

#   def process(row)
#     counts = counts_per_phrase( row[:text] )
#     return unless counts.present?

#     {
#       url: row[:url],
#       phrase_counts: counts,
#     }
#   end

#   private

#   def counts_per_phrase(raw)
#     # Note: could use Parallel here - https://github.com/grosser/parallel
#     phrases.each_with_object( make_hash(0) ) do |phrase, results|
#       if (cnt = (raw.split(phrase).count - 1)) > 0
#         results[phrase] += cnt
#       end
#     end
#   end
# end

# source Kiba::Common::Sources::Enumerable, -> { SitePages.all_pages }

# transform ParseSitePageData
# transform PhraseCountFromRawText, PHRASES

# @phrase_counts ||= make_hash(0)
# @phrase_sources ||= make_hash([])

# transform do |row|
#   row[:phrase_counts].each do |phrase, count_at_url|
#     @phrase_sources[phrase] << row[:url]
#     @phrase_counts[phrase] += count_at_url
#   end

#   row
# end

# post_process do
#   puts '-' * 50
#   @phrase_sources.each do |phrase, urls|
#     next if urls.length == 0
#     urls.uniq!
#     puts "\t#{phrase}: present on #{urls.length} pages"
#     urls.sort.each {|url| puts "\t\t- #{url}"}
#     puts
#   end
#   puts '-' * 50
#   puts @phrase_counts.inspect.green
#   puts '-' * 50

#   puts
#   puts
#   puts "--- WARNING ---".yellow
#   puts "Spider has duplicate pages. Dedup e.g. https://store.deviantech.com/products/bamboo-sunglasses-carver?variant=32049456905"
#   puts "And e.g. same product with and without collection. Maybe extract a cannonical URL if available?"
# end

# # show_me!
# # destination Kiba::Common::Destinations::CSV, filename: KIBA_REPORT
