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

    def vector_from_array(v)
      vector.new(v)
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
