require 'cloudinit_userdata/errors'

module CloudInit
  class Userdata
    class Validator
      attr_accessor :userdata

      def initialize(userdata)
        self.userdata = userdata
      end

      def call
        case
        when ::CloudInit::Userdata::PREFIXES.none? { |prefix| value.start_with?(prefix) }
          raise InvalidUserdataType, 'Unrecognized userdata format'
        when userdata.script? then validate_script
        when userdata.cloud_config? then validate_cloud_config
        when userdata.json? then validate_json
        end
      end

      private

      def validate_script
        return if value =~ /^#!\S.+\n/
        raise InvalidUserdata, 'Script is not a properly formatted to call an executable on line 1'
      end

      def validate_cloud_config
        require 'yaml'
        YAML.safe_load(value)
      rescue Psych::SyntaxError => e
        raise ParseError, "Contains invalid YAML at line #{e.line}, column #{e.column}: #{e.problem} #{e.context}"
      end

      def validate_json
        require 'json'
        JSON.parse(value)
      rescue JSON::ParserError => e
        raise ParseError, "Contains invalid JSON: #{e.message.sub(/^(\d+): /, '')}"
      end

      def value
        @value ||= userdata.to_s(:human)
      end
    end
  end
end
