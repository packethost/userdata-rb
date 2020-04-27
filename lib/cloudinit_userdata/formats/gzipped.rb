require "zlib"
require "stringio"

module CloudInit
  class Userdata
    # This class is really just a special formatter that wraps another
    # formatter and delegates an un-gzipped version of the string to the
    # underlying parser.
    class Gzipped < Userdata
      PREFIX = "\x1F\x8B".b.freeze

      attr_accessor :formatter

      def initialize(raw)
        super
        self.formatter = CloudInit::Userdata.parse(self.raw)
      end

      def raw(decompressed = true)
        if decompressed
          Zlib::GzipReader.new(StringIO.new(super())).read
        else
          super()
        end
      end

      def empty?
        formatter.empty?
      end

      def validate
        formatter.validate
      end

      def to_s
        raw(false)
      end

      def self.match?(value)
        !value.nil? && value[0..1] == PREFIX
      end
    end
  end
end
