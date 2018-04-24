class PhraseCountFromText
  attr_reader :phrases
  def initialize(phrases)
    @phrases = phrases.map(&:downcase)
  end

  def process(row)
    counts = counts_per_phrase( row[:text] )
    return unless counts.present?

    {
      url: row[:url],
      phrase_counts: counts,
    }
  end

  private

  def counts_per_phrase(raw)
    # Note: could use Parallel here - https://github.com/grosser/parallel
    phrases.each_with_object( make_hash(0) ) do |phrase, results|
      if (cnt = (raw.split(phrase).count - 1)) > 0
        results[phrase] += cnt
      end
    end
  end
end