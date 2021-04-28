# frozen_string_literal: true
module ActiveRecordReadOnlyErrorFallback
  module Extensions
    module Transaction
      def transaction(*)
        ActiveRecordReadOnlyErrorFallback::TransactionFallback.call { super }
      end
    end
  end
end
ActiveRecord::Base.singleton_class.prepend(ActiveRecordReadOnlyErrorFallback::Extensions::Transaction)
