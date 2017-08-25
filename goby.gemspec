# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goby/version'

Gem::Specification.new do |spec|
  spec.name          = "goby"
  spec.version       = Goby::VERSION.dup
  spec.authors       = ["Nicholas Skinsacos"]
  spec.email         = ["nskins@umich.edu"]

  spec.summary       = %q{Framework for creating text RPGs.}
  spec.homepage      = "https://github.com/nskins/goby"
  spec.license       = "MIT"

  spec.files = Dir["{lib}/**/*", "LICENSE", "README.md" ]
  spec.files = Dir["{exe}/**/*", "{lib}/**/*", "{res}/**/*", "LICENSE", "README.md" ]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "i18n", "~> 0.8"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
