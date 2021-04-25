require_relative 'lib/active_record_read_only_error_fallback/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record_read_only_error_fallback"
  spec.version       = ActiveRecordReadOnlyErrorFallback::VERSION
  spec.authors       = ["nalabjp"]
  spec.email         = ["nalabjp@gmail.com"]

  spec.summary       = %q{Automatically re-execute SQL with writing role, when ActiveRecord::ReadOnlyError occurred.}
  spec.description   = %q{Automatically re-execute SQL with writing role, when ActiveRecord::ReadOnlyError occurred.}
  spec.homepage      = "https://github.com/nalabjp/active_record_read_only_error_fallback"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nalabjp/active_record_read_only_error_fallback"
  # spec.metadata["changelog_uri"] = "https://github.com/nalabjp/active_record_read_only_error_fallback/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 6.0"
  spec.add_dependency "request_store"
end
