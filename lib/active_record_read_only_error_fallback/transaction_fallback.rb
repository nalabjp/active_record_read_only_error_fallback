# frozen_string_literal: true
module ActiveRecordReadOnlyErrorFallback
  module TransactionFallback
    extend Writable

    def self.call
      if ActiveRecord::Base.connected_to?(role: ActiveRecord::Base.reading_role)
        with_writable_connection(caller_locations) { yield }
      else
        yield
      end
    end
  end
end
