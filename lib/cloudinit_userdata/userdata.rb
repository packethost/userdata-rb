require 'cloudinit_userdata/errors'

module CloudInit
  class Userdata
    @formats = []

    attr_accessor :raw
    alias to_s raw

    def initialize(raw)
      self.raw = raw
    end

    def empty?
      false
    end

    def validate
      # noop
    end

    def valid?
      validate
      true
    rescue InvalidUserdata
      false
    end

    def self.match?(_value)
      raise NotImplementedError
    end

    def self.mimetypes
      []
    end

    def self.parse(value)
      formatter = @formats.find { |f| f.match?(value) }
      raise InvalidFormat, 'Unrecognized userdata format' unless formatter
      formatter.new(value)
    end

    def self.register_format(klass)
      @formats << klass unless @formats.include?(klass)
    end

    class << self
      attr_reader :formats
    end
  end
end
