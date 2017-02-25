module Stribog
  # BinaryVector
  #
  # @author WildDima
  module Stage
    class Final < Base
      attr_accessor :n
      attr_accessor :sum
      attr_accessor :digest_length
      attr_accessor :hash_vector
      attr_accessor :message_vector
      attr_accessor :message_head
      attr_accessor :current_vector

      def initialize(prev_stage)
        super(prev_stage)
      end

      def call
        set_params
        final
      end

      private

      def set_params
         @n = prev_stage_call[:n]
         @sum = prev_stage_call[:sum]
         @digest_length = prev_stage_call[:digest_length]
         @hash_vector = prev_stage_call[:hash_vector]
         @message_vector = prev_stage_call[:message_vector]
         @message_head = nil
      end

      def return_params
        {
          n: n,
          sum: sum,
          digest_length: digest_length,
          hash_vector: hash_vector,
          message_vector: message_vector
        }
      end

      def final
        sum = addition_in_ring(sum.to_dec, message_vector.padding.to_dec)
        n = addition_in_ring(n.to_dec, message_vector.to_dec)
        hash_vector = compress(n: n.addition(size: HASH_LENGTH),
                               message: message_vector.padding,
                               hash_vector: hash_vector)

        compress(sum: sum, n: n, hash_vector: hash_vector)
      end

      def slice_message_head(message_vector)
        vector.new(message_vector.vector[0...-HASH_LENGTH])
      end

      # Method, which slices head of tail
      def slice_message_tail(message_vector)
        vector.new(message_vector.vector[-HASH_LENGTH..-1])
      end

      # Compression method
      def compress(message:, hash_vector:, n: empty_vector)
        Compression.new(n, message, hash_vector).call
      end

      def addition_in_ring(first, second, ring = (2*8)**HASH_LENGTH, size: 64)
        vector.convert((first + second) % ring)
      end
    end
  end
end

