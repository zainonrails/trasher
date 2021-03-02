
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trasher/version'

Gem::Specification.new do |spec|
  spec.name          = 'trasher'
  spec.version       = Trasher::VERSION
  spec.authors       = ['Zain Butt']
  spec.email         = %w[xainbutt28@gmail.com zain@sendoso.com]

  spec.summary       = 'Soft Delete records with deleted_at and deleted_by'
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'activerecord', '~> 6.1.3'
  spec.add_development_dependency 'bundler', '~> 2.1.4'
  spec.add_development_dependency 'byebug', '~> 11.0.1'
  spec.add_development_dependency 'pg', '~> 0.18.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.82'
end
