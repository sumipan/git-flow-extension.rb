# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_flow_extension/version'

Gem::Specification.new do |spec|
  spec.name          = "git-flow-extension"
  spec.version       = GitFlowExtension::VERSION
  spec.authors       = ["takashi nagayasu"]
  spec.email         = ["ngys@g-onion.org"]
  spec.summary       = %q{Git flow extension.}
  spec.description   = %q{Git flow extension.}
  spec.homepage      = "https://github.com/sumipan/git-flow-extension.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "github_api", "~> 0.12"
  spec.add_dependency "git", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
