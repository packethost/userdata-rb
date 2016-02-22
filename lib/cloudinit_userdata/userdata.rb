require 'zlib'
require 'stringio'
require 'cloudinit_userdata/validator'

module CloudInit
  class Userdata
    GZIP_PREFIX = "\x1F\x8B".b.freeze
    SHEBANG = '#!'.freeze
    CLOUD_CONFIG_PREFIX = "#cloud-config\n".freeze
    JSON_PREFIXES = %w([ {).freeze
    PREFIXES = JSON_PREFIXES + [
      SHEBANG, CLOUD_CONFIG_PREFIX,
      '#include', '#upstart-job', '#cloud-boothook', '#part-handler'
    ].freeze

    attr_accessor :raw

    def initialize(raw)
      self.raw = raw
    end

    def script?
      to_s(:human).start_with?(SHEBANG)
    end

    def cloud_config?
      to_s(:human).start_with?(CLOUD_CONFIG_PREFIX)
    end

    def json?
      JSON_PREFIXES.include?(to_s(:human)[0])
    end

    def gzipped?
      !raw.nil? && raw[0..1] == GZIP_PREFIX
    end

    def decompressed
      Zlib::GzipReader.new(StringIO.new(raw)).read
    end

    def valid?
      validate
      true
    rescue InvalidUserdata
      false
    end

    def validate
      Validator.new(self).call
    end

    def to_s(format = nil)
      case format
      when nil, :raw then raw
      when :human, :decompressed
        gzipped? ? decompressed : raw
      end
    end
  end
end
