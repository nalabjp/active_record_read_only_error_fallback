# frozen_string_literal: true

RSpec.describe ActiveRecordReadOnlyErrorFallback::Logging do
  let(:result) { Struct.new('LoggingResult', :cause, :locations).new }
  let(:handler) { ->(args) { result.cause = args[:cause]; result.locations = args[:locations] } }

  before { described_class.handler = handler }

  subject { described_class.call(cause: 'TRANSACTION', locations: caller_locations) }

  it do
    is_expected
    expect(result.cause).to eq 'TRANSACTION'
    expect(result.locations).to all(be_instance_of Thread::Backtrace::Location)
  end
end
