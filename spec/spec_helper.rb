# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
ENV['DB'] ||= 'mysql'

require "bundler/setup"
Bundler.require

require 'fake_app/rails_app'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end
