# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nora_mark_htmlbook/version'

Gem::Specification.new do |spec|
  spec.name          = "nora_mark_htmlbook"
  spec.version       = NoraMark::Htmlbook::VERSION
  spec.authors       = ["Satoshi KOJIMA"]
  spec.email         = ["skoji@mac.com"]
  spec.summary       = %q{HTMLBook Generator plugin for NoraMark.}
  spec.description   = %q{HTMLBook Generator plugin for NoraMark.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nora_mark", ">= 0.2beta10"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "nokogiri", "~> 1.6.0"
end
