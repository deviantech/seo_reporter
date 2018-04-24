require 'json'

class Site::Pages

  def initialize(site: 'https://wearpanda.com/')
    @site = site
  end

  def cache_file
    "tmp/#{ URI.parse(@site).host.gsub('.', '-') }.json"
  end

  def clear_cache!
    File.unlink(CACHE_FILE) if File.exists?(CACHE_FILE)
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

  def spider_opts
    {
      ignore_links: [
        %{\?variant=}
      ]
    }
  end

  def from_live
    url_map = make_hash([])
    url_text = {}

    spider = Spidr.site( @site, spider_opts ) do |spider|
      spider.every_link do |origin, dest|
        url_map[dest] << origin
      end

      spider.every_html_page do |page|
        # <link rel="canonical" href="https://wearpanda.com/products/bamboo-sunglasses-carver" itemprop="url">
        canonical_url = if elem = page.at('link[rel="canonical"]')
          if attr = elem.attributes['href']
            attr.value
          end
        end

        should_parse = if canonical_url
          if canonical_url == page.url.to_s
            puts(">>> [canonical] #{page.url}".cyan)
            true
          else
            puts(">>> [alias] #{page.url}".light_black) if ENV['DEBUG']
            false
          end
        else
          puts ">>> [SKIPPING: no canonical URL, hopefully a redirect?] #{page.url}".yellow
          false
        end

        if should_parse
          raise("Already seen URL: #{page.url}") if url_text.key?(page.url.to_s)
          url_text[page.url.to_s] = page.body.force_encoding("utf-8")
        end
      end
    end


    puts "\n\n\n\n"

    spider.failures.each do |url|
      puts "\nBroken link #{url} found in:".red
      url_map[url].each { |page| puts "\t- #{page}" }
    end

    File.open(CACHE_FILE, 'w') { |file| file.write( url_text.to_json ) }

    url_text
  end

  def from_cache
    File.exists?(CACHE_FILE) ? JSON.parse(File.read(CACHE_FILE)) : from_live
  end

end