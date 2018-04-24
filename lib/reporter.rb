require 'lib/site/page'
require 'lib/site/pages'

def make_hash(default)
  Hash.new { |hash,key| hash[key] = default }
end


class Reporter
  class << self

    def top_words
      pages = SitePages.new
      top = pages.word_counts.to_a.sort_by {|tuple| -tuple[1]}.take(50)
      total = pages.all_pages.count.to_f

      puts "Top #{top.length} words over all #{total.to_i} site pages:"
      top.each do |tuple|
        puts tuple.join(': ') + " (about #{'%.2f' % (tuple[1] / total)} per page)"
      end
    end

    def keyword_report(write: false)
      keywords = CSV.read(KEYWORD_REPORT_IN).map {|r| r[0].to_s.downcase.strip }
      data = SitePages.new.phrase_counts( keywords.uniq ).to_a.sort_by {|tuple| -tuple[1]}

      data.reverse.each do |k,v|
        puts "#{k.cyan}: #{v}"
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

    def page_report
      # 2 - per url:
      #   page title
      #   metas: keyword description
      #   text of all h1 / h2 / h3 ...
      #   --
      #   image:
      #     src url
      #     alt
      #
      #   links:
      #     url linking to
      #     anchor text
    end

  end
end