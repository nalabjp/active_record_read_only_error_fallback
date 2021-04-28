# frozen_string_literal: true

RSpec.describe ActiveRecordReadOnlyErrorFallback::TransactionFallback do
  let(:result) { Struct.new('LoggingResult', :cause, :locations).new }
  let(:logging) { ->(args) { result.cause = args[:cause]; result.locations = args[:locations] } }

  before do
    ActiveRecordReadOnlyErrorFallback.logging = logging
  end

  after do
    ActiveRecordReadOnlyErrorFallback.logging = nil
  end

  context 'Switch to writing role connection' do
    it do
      ActiveRecord::Base.connected_to(role: ActiveRecord::Base.reading_role, prevent_writes: true) do
        described_class.call do
          expect(ActiveRecord::Base.connected_to?(role: ActiveRecord::Base.writing_role)).to eq true
        end
      end

      expect(result.cause).to eq 'TRANSACTION'
      expect(result.locations).to all(be_instance_of Thread::Backtrace::Location)
    end
  end

  context 'Extensions::Transaction#transaction' do
    context 'Switch to writing role connection and start transaction' do
      context 'The reciever is class' do
        it do
          ActiveRecord::Base.connected_to(role: ActiveRecord::Base.reading_role, prevent_writes: true) do
            User.transaction do
              expect(ActiveRecord::Base.connected_to?(role: ActiveRecord::Base.writing_role)).to eq true
              expect(ActiveRecord::Base.connection.transaction_open?).to eq true
            end
          end

          expect(result.cause).to eq 'TRANSACTION'
          expect(result.locations).to all(be_instance_of Thread::Backtrace::Location)
        end
      end

      context 'The reciever is instance' do
        it do
          ActiveRecord::Base.connected_to(role: ActiveRecord::Base.reading_role, prevent_writes: true) do
            User.new.transaction do
              expect(ActiveRecord::Base.connected_to?(role: ActiveRecord::Base.writing_role)).to eq true
              expect(ActiveRecord::Base.connection.transaction_open?).to eq true
            end
          end

          expect(result.cause).to eq 'TRANSACTION'
          expect(result.locations).to all(be_instance_of Thread::Backtrace::Location)
        end
      end
    end
  end
end
