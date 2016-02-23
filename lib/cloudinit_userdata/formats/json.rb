require 'json'
require 'cloudinit_userdata/errors'

module CloudInit
  class Userdata
    class JSON < Userdata
      PREFIXES = %w([ {).freeze
      MIMETYPES = %w(application/json).freeze

      def validate
        JSON.parse(raw)
      rescue JSON::ParserError => e
        raise ParseError, "Contains invalid JSON: #{e.message.sub(/^(\d+): /, '')}"
      end

      def self.match?(value)
        PREFIXES.any? { |prefix| value.start_with?(prefix) }
      end

      def self.mimetypes
        MIMETYPES
      end
    end
  end
end
