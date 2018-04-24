require 'spidr'

module Site
  module Spider
    module_function

    def call(site:, options: {})
      url_map = make_hash([])
      url_text = {}

      Spidr.site( site, options ) do |spider|
        spider.every_link do |origin, dest|
          url_map[dest] << origin
        end

        spider.every_html_page do |page|
          if should_parse?(page)
            raise("Already seen URL: #{page.url}") if url_text.key?(page.url.to_s) # Ensure only handling each URL once
            url_text[page.url.to_s] = page.body.force_encoding("utf-8")
          end
        end
      end.failures.each do |url|
        SeoReporter.logger.fatal "\nBroken link #{url} found in:"
        url_map[url].each { |page| SeoReporter.logger.warn "\t- #{page}" }
      end

      url_text
    end

    # To avoid doublecounting SEO entities, ideally we'd only parse canonical URLs.
    # In the case of pages without a canonical link tag (e.g. below), default behavior
    # is to warn but still process. Pages with canonical link tags will be ignored unless
    # the current url matches that in the tag.
    #     <link rel="canonical" href="https://somesite.org/the/actual/page">
    def should_parse?(page)
      canonical_url = if elem = page.at('link[rel="canonical"]')
        if attr = elem.attributes['href']
          attr.value
        end
      end

      if canonical_url
        if canonical_url == page.url.to_s
          SeoReporter.logger.info(">>> [canonical] #{page.url}")
          true
        else
          SeoReporter.logger.debug(">>> [alias] #{page.url}")
          false
        end
      else
        SeoReporter.logger.warn ">>> [SKIPPING: no canonical URL, hopefully a redirect?] #{page.url}"
        false
      end
    end

  end
end