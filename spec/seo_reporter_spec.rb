RSpec.describe SeoReporter do
  it "has a version number" do
    expect(SeoReporter::VERSION).not_to be nil
  end

  let(:site) { ENV.fetch('SITE') { 'http://localhost:3000/' } }

  it "loads site data" do
    SeoReporter.top_words(site: site)
  end
end
