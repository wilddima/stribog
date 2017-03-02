module Stribog
  # CreateHash
  #
  # Class, which creates digests.
  # @author WildDima
  class CreateHash
    # Original message
    #
    # @api public
    # @example
    #   hash.message
    # @return [String] contains original message
    attr_reader :message

    # Length of digest. Should be equal to 256 or 512.
    #
    # @api public
    # @example
    #   digest.digest_length
    # @return [Fixnum] binary representation of digest
    attr_reader :digest_length

    # Contain message as instance of BinaryVector
    #
    # @api public
    # @example
    #   digest.message_vector
    # @return [BinaryVector] binary representation of message
    attr_reader :message_vector
    attr_reader :vector


    def initialize(message, transformation = :from_hex, vector = Stribog.vector)
      @message = message
      @transformation = transformation
      @vector = vector
    end

    # Create digest of {#message}. Default equal to 512.
    #
    # @example
    #   Stribog::CreateHash.new('ruby').call(256)
    #   Stribog::CreateHash.new('ruby').call(512)
    # @author WildDima
    def call(digest_length = HASH_LENGTH)
      @digest_length = digest_length
      return_hash(
        Stage::Final.new(
          Stage::Compression.new(
            Stage::Initial.new(self)
          )
        ).call
      )
    end

    private

    # Create instance vars for hashing
    def prepare_hash_params(digest_length:)
      @n = binary_vector_field_by
      @sum = binary_vector_field_by
      @digest_length = digest_length
      @hash_vector = create_hash_vector

      @message_vector = binary_vector.send(@transformation, message)
    end

    # Create hash_vector for hashing
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

    # Method, which slices longer messages, and hashings them by parts.
    def compact_message(sum:, n:, message_vector:, hash_vector:, message_head: nil)
      current_vector = message_head || message_vector
      if current_vector.size < HASH_LENGTH
        return { sum: sum, n: n, message_vector: current_vector,
                 hash_vector: hash_vector }
      end

      compact_message(
        sum: addition_in_ring_to_binary(sum.to_dec, current_vector.to_dec),
        n: addition_in_ring_to_binary(n.to_dec, slice_message_tail(current_vector).size),
        message_vector: message_vector,
        hash_vector: compress(n: n, message: slice_message_tail(current_vector),
                              hash_vector: hash_vector),
        message_head: slice_message_head(current_vector)
      )
    end

    # Method, which slices head of message
    def slice_message_head(message_vector)
      binary_vector_from_array(message_vector.vector[0...-HASH_LENGTH])
    end

    # Method, which slices head of tail
    def slice_message_tail(message_vector)
      binary_vector_from_array(message_vector.vector[-HASH_LENGTH..-1])
    end

    # Method, which implements main hashing
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

    # Method, which implements final compression
    def final_compression(sum:, n:, hash_vector:)
      compress(message: sum, hash_vector: compress(message: n, hash_vector: hash_vector))
    end

    # Method, which return digest, dependent on them length
    def return_hash(final_vector)
      case digest_length
      when 512
        create_digest(final_vector)
      when 256
        create_digest(vector_from_array(final_vector[0..31]))
      else
        raise ArgumentError,
              "digest length must be equal to 256 or 512, not #{digest_length}"
      end
    end

    # Method implements addition in ring
    def addition_in_ring(first, second, ring)
      (first + second) % ring
    end

    # Method implements addition in ring and creates binary vector
    def addition_in_ring_to_binary(first, second, ring = 2**HASH_LENGTH, size: HASH_LENGTH)
      binary_vector.from_byte(addition_in_ring(first, second, ring), size: size)
    end

    # Compression method
    def compress(message:, hash_vector:, n: binary_vector_field_by)
      Compression.new(n, message, hash_vector).call
    end

    def vector_from_array(v)
      vector.new(v)
    end

    # Method creates binary vector and fields it by passed values
    def binary_vector_field_by(size: HASH_LENGTH, value: 0)
      binary_vector_from_array(Array.new(size, value))
    end

    # Create new instance of Digest
    def create_digest(vector)
      digest.new(vector: vector)
    end

    def digest
      @digest ||= Digest
    end
  end
end
