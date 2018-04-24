module Site
  class Page

    STOPWORDS = %w(a and the to on that our in with var is as for it of null true
      false id close or these log also can are its this do us than then an we menu
      search not you any all out be)

    attr_reader :url, :html
    def initialize(url, html)
      @url, @html = url, html
    end

    def doc
      @doc ||= Nokogiri::HTML.parse(html)
    end

    def text
      @text ||= doc.at('body')&.text.to_s.downcase
    end

  end
end