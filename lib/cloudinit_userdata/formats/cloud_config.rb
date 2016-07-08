require 'yaml'
require 'cloudinit_userdata/errors'

module CloudInit
  class Userdata
    class CloudConfig < Userdata
      PREFIX = "#cloud-config\n".freeze
      MIMETYPES = %w(text/cloud-config).freeze

      def validate
        YAML.safe_load(raw, [Date])
      rescue Psych::SyntaxError => e
        raise ParseError, "Contains invalid YAML at line #{e.line}, column #{e.column}: #{e.problem} #{e.context}"
      rescue Psych::DisallowedClass
        raise ParseError, 'Contains invalid YAML: Disallowed Class'
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
