class ParseUrlAndText
  def process(page)
    return unless page.html&.length.to_i > 0
    return unless text = parsed_text(page)

    {
      url: page.url,
      text: text,
    }
  end

  private

  def parsed_text(page)
    Nokogiri::HTML(page.html).at('body')&.text&.downcase
  end
end
