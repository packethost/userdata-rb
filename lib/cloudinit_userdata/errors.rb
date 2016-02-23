module CloudInit
  class Userdata
    class Error < RuntimeError; end
    class InvalidUserdata < Error; end
    class InvalidFormat < InvalidUserdata; end
    class ParseError < InvalidUserdata; end
  end
end
