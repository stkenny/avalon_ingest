# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'avalon_ingest/version'

Gem::Specification.new do |spec|
  spec.name          = "avalon_ingest"
  spec.version       = AvalonIngest::VERSION
  spec.authors       = ["Stuart Kenny"]
  spec.email         = ["kennystu@gmail.com"]

  spec.summary       = %q{Gem of Avalon ingest functionality}
  spec.description   = %q{Ingets functionality taken from Avalon.}
  spec.homepage      = "https://github.com/stkenny/avalon_ingest"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["app","lib"]

  spec.add_dependency "rails", ">= 3.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "hashdiff"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "fakefs"

  spec.add_dependency 'iconv'
  spec.add_dependency 'roo'
end
