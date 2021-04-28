# frozen_string_literal: true
module ActiveRecordReadOnlyErrorFallback
  module Writable
    def with_writable_connection(cause:, locations:)
      ActiveRecord::Base.connected_to(role: ActiveRecord::Base.writing_role, prevent_writes: false) do
        yield
      ensure
        # Mark to `RequestStore` for update `last_write_timestamp` to cookie with `ActiveRecordReadOnlyErrorFallback::DatabaseResolver`
        RequestStore.store[REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP] = true

        Logging.call(cause: cause, locations: locations)
      end
    end
  end
end
