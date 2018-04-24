class ParseUrlAndText
  def process(page)
    return unless page.html.present?
    return unless (text = parsed_text(page)).present?

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
