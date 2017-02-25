module Stribog
  # BinaryVector
  #
  # @author WildDima
  module Stage
    class Initial < Base
      def initialize(prev_stage)
        super(prev_stage)
      end

      def call
        return_params
      end

      private

      def return_params
        {
          n: empty_vector,
          sum: empty_vector,
          digest_length: digest_length,
          hash_vector: hash_vector,
          message_vector: message_vector
        }
      end

      def hash_vector
        case digest_length
        when 512
          empty_vector
        when 256
          field_vector(value: 1)
        else
          raise ArgumentError,
                "digest length must be equal to 256 or 512, not #{digest_length}"
        end
      end

      def digest_length
        @digest_length ||= prev_stage.digest_length
      end

      def message_vector
        @message_vector ||= vector.convert(prev_stage.message)
      end
    end
  end
end

