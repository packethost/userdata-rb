require "cloudinit_userdata/errors"

module CloudInit
  class Userdata
    class PowerShell < Userdata
      PREFIX = "#ps1".freeze
      POWER_SHELL_REGEXP = /^#ps1\S*\n/
      MIMETYPES = %w(text/power-shell).freeze

      def validate
        return if raw =~ POWER_SHELL_REGEXP
        raise InvalidUserdata, "Script is not properly formatted to call an executable on line 1"
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
