require 'byebug'
module Stribog
  # Hash function
  #
  # @author WildDima
  class CreateHash
    attr_reader :binary_vector, :message_adapter, :message, :digest_length, :message_vector

    HASH_LENGTH = 512

    def initialize(message, binary_vector: BinaryVector)
      @binary_vector = binary_vector
      @message = binary_vector.from_hex(message)
      @n = new_binary_vector(Array.new(HASH_LENGTH, 0))
      @sum = new_binary_vector(Array.new(HASH_LENGTH, 0))
    end

    def call(digest_length = HASH_LENGTH)
      @digest_length = digest_length
      @hash_vector = create_hash_vector
      @message_vector = message.dup

      while message_vector.size > HASH_LENGTH
        message_vector = new_binary_vector(message_vector.vector[-HASH_LENGTH..-1])
        message_cut!(sum: @sum, n: @n, message: message_vector, hash_vector: @hash_vector)
        @message_vector = new_binary_vector(message_vector.vector[0...-HASH_LENGTH])
      end

      core_hashing!(sum: @sum, n: @n, message: @message_vector, hash_vector: @hash_vector)

      @hash_vector = compress(message: @n, hash_vector: @hash_vector)

      @hash_vector = compress(message: @sum, hash_vector: @hash_vector)

      hash_vector
    end

    # TODO: MORE DRY
    def hash_vector
      case digest_length
      when 512
        @hash_vector
      when 256
        new_binary_vector(@hash_vector[0..255])
      else
        raise ArgumentError,
              "digest length must be equal to 256 or 512, not #{digest_length}"
      end
    end

    private

    def create_hash_vector
      case digest_length
      when 512
        new_binary_vector(Array.new(512, 0))
      when 256
        new_binary_vector(Array.new(64, '00000001').join.chars.map(&:to_i))
      else
        raise ArgumentError,
              "digest length must be equal to 256 or 512, not #{digest_length}"
      end
    end

    def message_cut!(sum:, n:, message:, hash_vector:)
      @hash_vector = compress(n: n, message: message, hash_vector: hash_vector)
      @n = addition_in_ring_to_binary(n.to_dec, message.size)
      @sum = addition_in_ring_to_binary(sum.to_dec, message.to_dec)
    end

    def core_hashing!(sum:, n:, message:, hash_vector:)
      @hash_vector = compress(n: n.addition_by_zeros(size: HASH_LENGTH),
                              message: message.addition_bit_padding(size: HASH_LENGTH),
                              hash_vector: hash_vector)
      @n = addition_in_ring_to_binary(n.to_dec, message.size)
      @sum = addition_in_ring_to_binary(sum.to_dec,
                                        message.addition_bit_padding(size: HASH_LENGTH).to_dec)
    end

    def addition_in_ring(first, second, ring)
      (first + second) % ring
    end

    def addition_in_ring_to_binary(first, second, ring = 2**HASH_LENGTH, size: HASH_LENGTH)
      binary_vector.from_byte(addition_in_ring(first, second, ring), size: size)
    end

    def compress(message:, hash_vector:, n: nil)
      n ||= new_binary_vector(Array.new(HASH_LENGTH, 0))
      Compression.new(n, message, hash_vector).start
    end

    def new_binary_vector(vector)
      binary_vector.new(vector)
    end
  end
end
