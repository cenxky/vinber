# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vinber/version'

Gem::Specification.new do |spec|
  spec.name          = "vinber"
  spec.version       = Vinber::VERSION
  spec.authors       = ["cenxky"]
  spec.email         = ["cenxky@gmail.com"]

  spec.summary       = %q{Vinber is a rails enumeration tool, much easier for i18n.}
  spec.description   = %q{Vinber is a rails enumeration tool, much easier for i18n.}
  spec.homepage      = "https://github.com/cenxky/vinber"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
