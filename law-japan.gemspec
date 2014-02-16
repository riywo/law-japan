# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'law/japan/version'

Gem::Specification.new do |spec|
  spec.name          = "law-japan"
  spec.version       = Law::Japan::VERSION
  spec.authors       = ["Ryosuke IWANAGA"]
  spec.email         = ["riywo.jp@gmail.com"]
  spec.summary       = %q{Operating Japanese laws}
  spec.description   = %q{This is a library for Japanese laws}
  spec.homepage      = "https://github.com/riywo/law-japan"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "git"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
