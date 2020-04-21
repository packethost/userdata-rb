require 'cloudinit_userdata/errors'

module CloudInit
  class Userdata
    class JinjaTemplate < Userdata
      PREFIX = "## template: jinja\n"
      MIMETYPES = %w(text/jinja).freeze

      def validate
        return if raw.start_with?(PREFIX)
        raise InvalidUserdata, 'Script is not properly formatted to call an executable on line 1'
      end

      def self.match?(value)
        value.start_with?(PREFIX)
      end

      def self.mimetypes
        MIMETYPES
      end
    end
  end
end
