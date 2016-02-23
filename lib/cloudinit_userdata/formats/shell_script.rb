require 'cloudinit_userdata/errors'

module CloudInit
  class Userdata
    class ShellScript < Userdata
      SHEBANG = '#!'.freeze
      SHEBANG_REGEXP = /^#!\S.+\n/
      MIMETYPES = %w(text/x-shellscript).freeze

      def validate
        return if raw =~ SHEBANG_REGEXP
        raise InvalidUserdata, 'Script is not a properly formatted to call an executable on line 1'
      end

      def self.match?(value)
        value.start_with?(SHEBANG)
      end

      def self.mimetypes
        MIMETYPES
      end
    end
  end
end
