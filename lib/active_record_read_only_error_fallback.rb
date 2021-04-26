# frozen_string_literal: true
require 'active_record'
require 'request_store'

module ActiveRecordReadOnlyErrorFallback
  REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP = 'active_record_read_only_error_fallback.require_update_last_write_timestamp'

  class << self
    def call
      yield
    rescue ActiveRecord::ReadOnlyError => e
      ActiveRecord::Base.connected_to(role: ActiveRecord::Base.writing_role, prevent_writes: false) do
        yield
      ensure
        # Mark to `RequestStore` for update `last_write_timestamp` to cookie with `ActiveRecordReadOnlyErrorFallback::DatabaseResolver`
        RequestStore.store[REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP] = true

        Logging.call(e)
      end
    end

    def logging=(callable)
      Logging.handler = callable
    end
  end
end

require 'active_record_read_only_error_fallback/version'
require 'active_record_read_only_error_fallback/logging'
require 'active_record_read_only_error_fallback/database_resolver'

ActiveSupport.on_load :active_record do
  db_config = Rails.application.config.database_configuration[Rails.env]
  adapter = db_config.size > 1 ? db_config.values.first['adapter'] : nil
  case adapter
  when 'mysql2'
    require 'active_record_read_only_error_fallback/mysql_database_statements'
  end
end
