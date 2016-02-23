# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudinit_userdata/version'

Gem::Specification.new do |spec|
  spec.name          = 'cloudinit_userdata'
  spec.version       = CloudInit::Userdata::VERSION
  spec.authors       = ['Jake Bell']
  spec.email         = %w(jake@packet.net)

  spec.summary       = %q{Ruby client for the parsing and validating CloudInit userdata}
  spec.description   = %q{Ruby client for the parsing and validating CloudInit userdata}
  spec.homepage      = 'https://www.packet.net'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = %w(lib)
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_dependency 'mail', '~> 2.6'

  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rdoc', '~> 4'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'simplecov', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'pry'
end
