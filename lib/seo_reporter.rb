require 'nokogiri'

require 'csv'
require 'logger'

def make_hash(default)
  Hash.new { |hash,key| hash[key] = default }
end

require "seo_reporter/version"

module Site
  autoload :Spider, 'site/spider'
end

require "site/page"
require "site/pages"


module SeoReporter
  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end


  KEYWORD_REPORT_IN = 'data/keywords-in.csv'
  KEYWORD_REPORT_OUT = 'data/keywords-out.csv'
  def self.keyword_report(site:, write: false)
    raise("First place a .csv file containing a list of keywords at #{KEYWORD_REPORT_IN}") unless File.exists?(KEYWORD_REPORT_IN)
    keywords = CSV.read(KEYWORD_REPORT_IN).map {|r| r[0].to_s.downcase.strip }
    data = Site::Pages.new(site: site).phrase_counts( keywords.uniq ).to_a.sort_by {|tuple| -tuple[1]}

    data.reverse.each do |k,v|
      puts "#{k}: #{v}"
    end

    if write
      CSV.open(KEYWORD_REPORT_OUT, "wb") do |csv|
        data.each do |k,v|
          csv << [k, v]
        end
      end
      puts "Wrote report (#{data.length} keywords) to #{KEYWORD_REPORT_OUT}".green
    end
  end

end