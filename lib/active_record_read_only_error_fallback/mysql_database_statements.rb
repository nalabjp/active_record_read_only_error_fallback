# frozen_string_literal: true
require "active_record/connection_adapters/mysql2_adapter"

module ActiveRecordReadOnlyErrorFallback
  module MysqlDatabaseStatements
    def execute(*)
      ActiveRecordReadOnlyErrorFallback.call { super }
    end

    private

    def exec_stmt_and_free(*)
      ActiveRecordReadOnlyErrorFallback.call { super }
    end
  end
end
ActiveRecord::ConnectionAdapters::Mysql2Adapter.prepend(ActiveRecordReadOnlyErrorFallback::MysqlDatabaseStatements)
