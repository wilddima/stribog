module Stribog
  # BinaryVector
  #
  # @author WildDima
  module Stage
    class Compression < Base
      def call
        set_params
        compression
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

      def compression
        self.current_vector = message_head || message_vector
        if current_vector.size * 8 < HASH_LENGTH
          return return_params
        end

        transformation
        compression
      end

      def transformation
        self.hash_vector = compress(n: n, message: slice_message_tail(current_vector), hash_vector: hash_vector)
        self.sum = addition_in_ring(sum.to_dec, current_vector.to_dec)
        self.n = addition_in_ring(n.to_dec, slice_message_tail(current_vector).size * 8)
        self.message_head = slice_message_head(current_vector)
      end
    end
  end
end
