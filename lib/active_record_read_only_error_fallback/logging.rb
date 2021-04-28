# frozen_string_literal: true
module ActiveRecordReadOnlyErrorFallback
  class Logging
    class << self
      attr_accessor :handler

      def call(cause:, locations:)
        handler.call(cause: cause, locations: locations) if handler&.respond_to?(:call)
      rescue
        # nothing to do
      end
    end
  end
end
