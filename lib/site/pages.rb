require 'json'
require 'fileutils'

module Site
  class Pages

    attr_reader :site
    def initialize(site:)
      @site = site
    end

    def cache_file
      "tmp/#{ URI.parse(@site).host.gsub('.', '-') }.json"
    end

    def clear_cache!
      File.unlink(cache_file) if File.exists?(cache_file)
    end

    def all_pages
      @all_pages ||= data.map do |k,v|
        Site::Page.new(k,v)
      end
    end

    def word_counts
      @word_counts ||= all_pages.each_with_object( make_hash(0) ) do |page, words|
        page.word_counts.each do |word, count|
          words[word] += count if word.present?
        end
      end
    end

    def phrase_counts(phrases)
      @phrase_counts ||= all_pages.each_with_object( make_hash(0) ) do |page, data|
        page.phrase_counts(phrases).each do |phrase, count|
          data[phrase] += count if phrase.present?
        end
      end
    end

    def data(cache: true)
      @data ||= cache ? from_cache : from_live
    end

    def spider_options
      {
        ignore_links: [ %{\?variant=} ]
      }
    end

    def from_live
      html_by_urls = Spider.call(site: @site, options: spider_options)

      FileUtils.mkdir_p( File.dirname(cache_file) )
      File.open(cache_file, 'w') { |file| file.write( html_by_urls.to_json ) }

      html_by_urls
    end

    def from_cache
      File.exists?(cache_file) ? JSON.parse(File.read(cache_file)) : from_live
    end

  end
end