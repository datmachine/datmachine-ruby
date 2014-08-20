#!/usr/bin/env gem build
# coding: utf-8

require "base64"
require File.expand_path('../lib/datmachine/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "datmachine"
  spec.version       = Datmachine::VERSION
  spec.authors       = ["efremov"]
  spec.email         = ["efremov@datmachine.co"]
  spec.description   = %q{Datmachine is a business intelligence solution for Internet companies.}
  spec.summary       = %q{https://datmachine.co/guides}
  spec.homepage      = "https://datmachine.co"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency("faraday", ['>= 0.8.6', '<= 0.9.0'])
  spec.add_dependency("faraday_middleware", '~> 0.9.0')
  spec.add_dependency("addressable", '~> 2.3.5')
  
end
