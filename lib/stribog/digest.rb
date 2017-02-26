require 'base64'

module Stribog
  # Digest
  #
  # Class, returning by CreateHash#call
  # Contains binary and hex representation of digest.
  # You can use {#binary} to get array and {#hex} to get digest in hash.
  # @author WildDima
  class Digest
    # Contains binary representation of hash
    #
    # @api public
    # @example
    #   digest.binary
    # @return [Array] binary representation of digest
    attr_reader :vector
    # Contains hex value of hash
    #
    # @api public
    # @example
    #   digest.hex
    # @return [String] hex representation of digest

    def initialize(vector:)
      @vector = vector
    end

    def hex
      vector.to_dec.to_s(16)
    end
    alias to_hex hex

    def base64
      Base64.encode64(hex)
    end

    def pack(meaning = 'C*')
      binary.to_byte_array.pack(meaning)
    end
  end
end
