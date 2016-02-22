module CloudInit
  class Error < RuntimeError; end
  class InvalidUserdata < Error; end
  class InvalidUserdataType < InvalidUserdata; end
  class ParseError < InvalidUserdata; end
end
