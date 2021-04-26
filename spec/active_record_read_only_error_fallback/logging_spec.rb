# frozen_string_literal: true

RSpec.describe ActiveRecordReadOnlyErrorFallback::Logging do
  let(:result) { Struct.new('LoggingResult', :error).new }
  let(:handler) { ->(e) { result.error = e } }

  before { described_class.handler = handler }

  subject { described_class.call("What's happened?") }

  it do
    is_expected
    expect(result.error).to eq "What's happened?"
  end
end
