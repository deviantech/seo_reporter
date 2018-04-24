class PhraseCountFromText
  attr_reader :phrases
  def initialize(phrases)
    @phrases = phrases.map(&:downcase)
  end

  def process(row)
    counts = counts_per_phrase( row[:text] )
    return unless counts&.length.to_i > 0

    {
      url: row[:url],
      phrase_counts: counts_per_phrase(raw),
    }
  end

  private

  def counts_per_phrase(raw)
    # Note: could use Parallel here - https://github.com/grosser/parallel
    phrases.each_with_object( make_hash(0) ) do |phrase, data|
      next if phrase =~ /\?{4,}/ # skip if a bunch of ??s
      data[phrase] += text.scan( scan_regex_for(phrase) ).length
    end
  end

  def scan_regex_for(phrase)
    /#{ phrase.gsub(/\s+/, '\s+') }/
  end

end