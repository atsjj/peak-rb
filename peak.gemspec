# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peak/version'

Gem::Specification.new do |spec|
  spec.name          = 'peak'
  spec.version       = Peak::VERSION
  spec.summary       = 'Peak'
  spec.authors       = ['Steve Jabour']
  spec.email         = ['steve@jabour.me']
  spec.files         = Dir['lib/**/*', 'Rakefile']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0', '>= 12.3.3'
  spec.add_development_dependency 'minitest', '~> 5.0'

  spec.add_runtime_dependency 'activesupport', '>= 6.0.0'
  spec.add_runtime_dependency 'dry-configurable', '>= 0.8.0'
  spec.add_runtime_dependency 'dry-core', '>= 0.4.0'
  spec.add_runtime_dependency 'dry-initializer', '>= 3.0.0'
  spec.add_runtime_dependency 'jwt', '>= 2.2.0'
end
