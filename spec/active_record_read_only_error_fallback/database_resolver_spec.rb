# frozen_string_literal: true

RSpec.describe ActiveRecordReadOnlyErrorFallback::DatabaseResolver do
  let(:resolver) { described_class.new(context_mock) }
  let(:context_mock) { instance_double(ActiveRecord::Middleware::DatabaseSelector::Resolver::Session) }

  before do
    RequestStore.clear!
    allow(resolver).to receive(:read_from_primary?).and_return(true)
  end

  context '#read' do
    subject { resolver.read {} }

    context 'RequestStore.store[ActiveRecordReadOnlyErrorFallback::REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP] is exists' do
      before do
        RequestStore.store[ActiveRecordReadOnlyErrorFallback::REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP] = true
        expect(context_mock).to receive(:update_last_write_timestamp)
      end

      it { is_expected }
    end

    context 'RequestStore.store[ActiveRecordReadOnlyErrorFallback::REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP] is not exists' do
      before do
        expect(context_mock).not_to receive(:update_last_write_timestamp)
      end

      it { is_expected }
    end
  end
end
