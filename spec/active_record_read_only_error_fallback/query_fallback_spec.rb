# frozen_string_literal: true

RSpec.describe ActiveRecordReadOnlyErrorFallback::QueryFallback do
  let(:result) { Struct.new('LoggingResult', :cause, :locations).new }
  let(:logging) { ->(args) { result.cause = args[:cause]; result.locations = args[:locations] } }

  before do
    RequestStore.clear!
    ActiveRecordReadOnlyErrorFallback.logging = logging
  end

  after do
    ActiveRecordReadOnlyErrorFallback.logging = nil
  end

  context 'with `reading_role` connection' do
    around do |ex|
      ActiveRecord::Base.connected_to(role: ActiveRecord::Base.reading_role, prevent_writes: true) { ex.run }
    end

    context 'Fallback successful' do
      subject { described_class.call { User.create!(name: 'nalabjp') } }

      it do
        expect(subject).to be_instance_of User
        expect(result.cause).to eq 'QUERY'
        expect(result.locations).to all(be_instance_of Thread::Backtrace::Location)
        expect(RequestStore.store[ActiveRecordReadOnlyErrorFallback::REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP]).to eq true
      end
    end

    context 'Fallback successful and expected error occurs' do
      subject { described_class.call { User.create!(name: nil) } }

      it do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
        expect(result.cause).to be_nil
        expect(result.locations).to be_nil
        expect(RequestStore.store[ActiveRecordReadOnlyErrorFallback::REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP]).to be_nil
      end
    end

    context 'Fallback successful, but unexpected error occurs' do
      subject { described_class.call { User.create!(name: 'nalabjp') } }

      let(:logging) { ->(_args) { raise 'Unexpected error' } }

      it do
        expect(subject).to be_instance_of User
        expect(RequestStore.store[ActiveRecordReadOnlyErrorFallback::REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP]).to eq true
      end
    end
  end

  context 'with `writing_role` connection' do
    around do |ex|
      ActiveRecord::Base.connected_to(role: ActiveRecord::Base.writing_role, prevent_writes: false) { ex.run }
    end

    context 'Do not fallback' do
      subject { described_class.call { User.create!(name: 'nalabjp') } }

      it { expect(subject).to be_instance_of User }
    end

    context 'Do not fallback successful and expected error occurs' do
      subject { described_class.call { User.create!(name: nil) } }

      it { expect { subject }.to raise_error ActiveRecord::RecordInvalid }
    end
  end
end
