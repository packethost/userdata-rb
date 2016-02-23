module CloudInit
  class Userdata
    class Blank < Userdata
      REGEXP = /\A[[:space:]]*\z/

      def self.match?(value)
        value.nil? || !REGEXP.match(value).nil?
      end

      def empty?
        true
      end
    end
  end
end
