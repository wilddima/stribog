require 'byebug'
module Stribog
  # Hash function
  #
  # @author WildDima
  class CreateHash
    attr_reader :vector_adapter, :message_adapter, :message, :digest_length

    HASH_LENGTH = 512

    def initialize(message, vector_adapter: BinaryVector, message_adapter: Message)
      @vector_adapter = vector_adapter
      @message_adapter = message_adapter
      @message = message
      @n = new_binary_vector(Array.new(HASH_LENGTH, 0))
      @sum = new_binary_vector(Array.new(HASH_LENGTH, 0))
    end

    def call(digest_length: HASH_LENGTH)
      @digest_length = digest_length
      @hash_vector = create_hash_vector

      while message.size > HASH_LENGTH
        message = new_message_from_bin new_binary_vector(@message.vector[-HASH_LENGTH..-1])
        message_cut!(sum: @sum, n: @n, message: message, hash_vector: @hash_vector)
        @message = new_message_from_bin new_binary_vector(@message.vector[0...-HASH_LENGTH])
      end

      core_hashing!(sum: @sum, n: @n, message: @message, hash_vector: @hash_vector)

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
      @hash_vector = compress(n: n, message: message.vector, hash_vector: hash_vector)
      @n = addition_in_ring_to_binary(n.to_dec, message.vector.size)
      @sum = addition_in_ring_to_binary(sum.to_dec, message.vector.to_dec)
    end

    def core_hashing!(sum:, n:, message:, hash_vector:)
      @hash_vector = compress(n: n.addition_to(size: HASH_LENGTH),
                              message: message.addition_to(size: HASH_LENGTH),
                              hash_vector: hash_vector)
      @n = addition_in_ring_to_binary(n.to_dec, message.size)
      @sum = addition_in_ring_to_binary(sum.to_dec, message.addition_to(size: HASH_LENGTH).to_dec)
    end

    def addition_in_ring(first, second, ring)
      (first + second) % ring
    end

    def addition_in_ring_to_binary(first, second, ring = 2**HASH_LENGTH, size: HASH_LENGTH)
      vector_adapter.from_byte(addition_in_ring(first, second, ring), size: size)
    end

    def compress(message:, hash_vector:, n: nil)
      n ||= new_binary_vector(Array.new(HASH_LENGTH, 0))
      Compression.new(n, message, hash_vector).start
    end

    def new_message_from_bin(bin)
      message_adapter.from_bin(bin)
    end

    def new_binary_vector(vector)
      vector_adapter.new(vector)
    end
  end
end
