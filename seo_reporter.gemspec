
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "seo_reporter/version"

Gem::Specification.new do |spec|
  spec.name          = "seo_reporter"
  spec.version       = SeoReporter::VERSION
  spec.authors       = ["Kali Donovan"]
  spec.email         = ["kali@deviantech.com"]

  spec.summary       = %q{Given a website, generate various SEO-related reports.}
  spec.description   = %q{Contains both code to spider/cache a website locally and ETL files ready for use with Kiba.}
  spec.homepage      = "https://github.com/deviantech/seo_reporter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "kiba"]

  spec.add_dependency "spidr"
  spec.add_dependency "nokogiri"
  spec.add_dependency "kiba"
  spec.add_dependency "kiba-common"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end
