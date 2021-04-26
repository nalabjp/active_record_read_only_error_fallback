# frozen_string_literal: true
module ActiveRecordReadOnlyErrorFallback
  class QueryFallback
    extend Writable

    def self.call
      yield
    rescue ActiveRecord::ReadOnlyError => e
      if ActiveRecord::Base.connection.transaction_open?
        raise e
      else
        with_writable_connection(e) { yield }
      end
    end
  end
end
