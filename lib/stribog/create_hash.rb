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
      @n = binary_vector_field_by
      @sum = binary_vector_field_by
    end

    def call(digest_length = HASH_LENGTH)
      create_hash_params!(digest_length: digest_length)

      return_hash(
        final_compression(
          core_hashing(
            compact_message(
              sum: @sum,
              n: @n,
              message_vector: message_vector,
              hash_vector: @hash_vector
            )
          )
        )
      )
    end

    private

    def create_hash_params!(digest_length:)
      @digest_length = digest_length
      @hash_vector = create_hash_vector
      @message_vector = message.dup
    end

    def create_hash_vector
      case digest_length
      when 512
        binary_vector_field_by(size: 512)
      when 256
        binary_vector_from_array(Array.new(64, '00000001').join.chars.map(&:to_i))
      else
        raise ArgumentError,
              "digest length must be equal to 256 or 512, not #{digest_length}"
      end
    end

    def compact_message(sum:, n:, message_vector:, hash_vector:, message_head: nil)
      if message_vector.size < HASH_LENGTH || !message_head.nil? && message_head.size < HASH_LENGTH
        return { sum: sum, n: n, message_vector: message_head || message_vector,
                 hash_vector: hash_vector }
      end

      compact_message(
        sum: addition_in_ring_to_binary(sum.to_dec, message_vector.to_dec),
        n: addition_in_ring_to_binary(n.to_dec, slice_message_tail(message_vector).size),
        message_vector: message_vector,
        hash_vector: compress(n: n, message: slice_message_tail(message_vector),
                              hash_vector: hash_vector),
        message_head: slice_message_head(message_vector)
      )
    end

    def slice_message_head(message_vector)
      binary_vector_from_array(message_vector.vector[0...-HASH_LENGTH])
    end

    def slice_message_tail(message_vector)
      binary_vector_from_array(message_vector.vector[-HASH_LENGTH..-1])
    end

    def core_hashing(sum:, n:, message_vector:, hash_vector:)
      new_sum = addition_in_ring_to_binary(sum.to_dec,
                                           message_vector
                                            .addition_bit_padding(size: HASH_LENGTH)
                                            .to_dec)

      new_n = addition_in_ring_to_binary(n.to_dec, message_vector.size)

      new_hash_vector = compress(n: n.addition_by_zeros(size: HASH_LENGTH),
                                 message: message_vector.addition_bit_padding(size: HASH_LENGTH),
                                 hash_vector: hash_vector)

      { sum: new_sum, n: new_n, hash_vector: new_hash_vector }
    end

    def final_compression(sum:, n:, hash_vector:)
      compress(message: sum, hash_vector: compress(message: n, hash_vector: hash_vector))
    end

    def return_hash(final_vector)
      case digest_length
      when 512
        final_vector
      when 256
        binary_vector_from_array(final_vector[0..255])
      else
        raise ArgumentError,
              "digest length must be equal to 256 or 512, not #{digest_length}"
      end
    end

    def addition_in_ring(first, second, ring)
      (first + second) % ring
    end

    def addition_in_ring_to_binary(first, second, ring = 2**HASH_LENGTH, size: HASH_LENGTH)
      binary_vector.from_byte(addition_in_ring(first, second, ring), size: size)
    end

    def compress(message:, hash_vector:, n: binary_vector_field_by)
      Compression.new(n, message, hash_vector).call
    end

    def binary_vector_from_array(vector)
      binary_vector.new(vector)
    end

    def binary_vector_field_by(size: HASH_LENGTH, value: 0)
      binary_vector_from_array(Array.new(size, value))
    end
  end
end
