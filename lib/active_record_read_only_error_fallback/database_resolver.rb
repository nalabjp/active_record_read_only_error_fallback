# frozen_string_literal: true

module ActiveRecordReadOnlyErrorFallback
  class DatabaseResolver < ActiveRecord::Middleware::DatabaseSelector::Resolver
    def read(*)
      super
    ensure
      context.update_last_write_timestamp if RequestStore.store[ActiveRecordReadOnlyErrorFallback::REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP]
    end
  end
end
