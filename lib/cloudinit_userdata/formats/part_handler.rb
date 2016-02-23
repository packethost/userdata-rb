module CloudInit
  class Userdata
    class PartHandler < Userdata
      PREFIX = '#part-handler'.freeze
      MIMETYPES = %w(text/part-handler).freeze

      def self.match?(value)
        value.start_with?(PREFIX)
      end

      def self.mimetypes
        MIMETYPES
      end
    end
  end
end
