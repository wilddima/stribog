module Stribog
  # BinaryVector
  #
  # @author WildDima
  module Stage
    class Base
      attr_reader :prev_stage
      attr_reader :vector

      def initialize(prev_stage, vector = ByteVector)
        @prev_stage = prev_stage
        @vector = vector
      end

      def call
        raise NotImplementedYet
      end

      def prev_stage_call
        @prev_stage_call ||= prev_stage.call
      end

      def field_vector(value:, size: 64)
        vector.new(Array.new(value, size))
      end

      def empty_vector(size: 64)
        field_vector(value: 0, size: size)
      end
    end
  end
end

