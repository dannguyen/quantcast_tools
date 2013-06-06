# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quantcast_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "quantcast_tools"
  spec.version       = QuantcastTools::VERSION
  spec.authors       = ["TK"]
  spec.email         = ["TK@TKgmail.com"]
  spec.description   = "TK"
  spec.summary       = "TK"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'hashie'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', "~>2.8"
  spec.add_development_dependency "fakeweb", ["~> 1.3"]
  
  spec.add_dependency "nokogiri"

end
