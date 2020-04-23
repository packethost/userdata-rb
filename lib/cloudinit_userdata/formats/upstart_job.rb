module CloudInit
  class Userdata
    class UpstartJob < Userdata
      PREFIX = "#upstart-job".freeze
      MIMETYPES = %w(text/upstart-job).freeze

      def self.match?(value)
        value.start_with?(PREFIX)
      end

      def self.mimetypes
        MIMETYPES
      end
    end
  end
end
