module CloudInit
  class Userdata
    class CloudBoothook < Userdata
      PREFIX = '#cloud-boothook'.freeze
      MIMETYPES = %w(text/cloud-boothook).freeze

      def self.match?(value)
        value.start_with?(PREFIX)
      end

      def self.mimetypes
        MIMETYPES
      end
    end
  end
end
