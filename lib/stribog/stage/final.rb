module Stribog
  # BinaryVector
  #
  # @author WildDima
  module Stage
    # Final
    #
    # @author WildDima
    class Final < Base
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

      def final
        self.hash_vector = compress(n: n.addition(size: HASH_LENGTH / 8),
                                    message: message_vector.padding,
                                    hash_vector: hash_vector)
        self.sum = addition_in_ring(sum.to_dec, message_vector.padding.to_dec)
        self.n = addition_in_ring(n.to_dec, message_vector.size * 8)

        compress(message: sum, hash_vector: compress(message: n, hash_vector: hash_vector))
      end
    end
  end
end
