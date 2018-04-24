class Site::Page

  STOPWORDS = %w(a and the to on that our in with var is as for it of null true false id close or these log also can are its this do us than then an we menu search not you any all out be)

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

  def words
    text.split(/\s+/)
  end

  def word_counts
    @word_counts ||= words.each_with_object( make_hash(0) ) do |word, words|
      next if word.blank? || STOPWORDS.include?(word)
      words[ word.gsub(/\W/, '') ] += 1
    end
  end

  def phrase_counts(phrases)
    @phrase_counts ||= phrases.each_with_object( make_hash(0) ) do |phrase, data|
      next if phrase =~ /\?{4,}/ # skip if a bunch of ??s
      data[phrase] += text.scan( scan_regex_for(phrase) ).length
    end
  end

  private

  def scan_regex_for(phrase)
    /#{ phrase.gsub(/\s+/, '\s+') }/
  end

end
