# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_net/version'

Gem::Specification.new do |spec|
  spec.name          = "social_net"
  spec.version       = SocialNet::VERSION
  spec.authors       = ["Jeremy Cohen Hoffing"]
  spec.email         = ["jeremy@collabcreators.com"]
  spec.summary       = %q{An API Client for social networks}
  spec.description   = %q{Retrieves information for Instagram users}
  spec.homepage      = "https://github.com/CollabCreators/social_net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "yard", "~> 0.8.7"
  spec.add_development_dependency "coveralls", "~> 0.7.1"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.19"
end
