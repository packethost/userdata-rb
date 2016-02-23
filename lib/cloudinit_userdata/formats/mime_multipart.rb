require 'mail'
require 'cloudinit_userdata/errors'

module CloudInit
  class Userdata
    class MimeMultipart < Userdata
      MATCH_STRING = 'Content-Type: multipart/mixed'.freeze
      MIMETYPES = %w(multipart/mixed).freeze

      attr_accessor :formatters

      def initialize(raw)
        super
        self.formatters = self.class.parse_formatters(raw)
      end

      def validate
        formatters.each(&:validate)
      end

      def empty?
        formatters.all?(&:empty?)
      end

      def self.match?(value)
        value.include?(MATCH_STRING)
      end

      def self.mimetypes
        MIMETYPES
      end

      def self.parse_formatters(raw)
        Mail.new(raw).parts.map do |part|
          mime = part.mime_type
          formatter = Userdata.formats.find { |f| f.mimetypes.include?(mime) }
          raise InvalidFormat, "Userdata format for mime type #{mime} not found" unless formatter
          formatter.new(part.body.raw_source)
        end
      end
    end
  end
end
