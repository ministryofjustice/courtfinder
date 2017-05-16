class UuidGenerator

  UUID_PATTERN = %r{
        \A
        [a-f\d]{8}
        -
        [a-f\d]{4}
        -
        [1-5]   # Version: http://tools.ietf.org/html/rfc4122#section-4.1.3
        [a-f\d]{3}
        -
        [89ab]  # Variant: http://tools.ietf.org/html/rfc4122#section-4.1.1
        [a-f\d]{3}
        -
        [a-f\d]{12}
        \z
      }x

  def generate
    @uuid = SecureRandom.uuid
    unless @uuid =~ UUID_PATTERN
      raise "UUID #{@uuid} does not validate against gov.uk regex!"
    end
    @uuid
  end

end
