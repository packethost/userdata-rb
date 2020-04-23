module CloudInit
  class Userdata
    class Include < Userdata
      PREFIX = "#include".freeze
      MIMETYPES = %w(text/x-include-url text/x-include-once-url).freeze

      def self.match?(value)
        value.start_with?(PREFIX)
      end

      def self.mimetypes
        MIMETYPES
      end
    end
  end
end
