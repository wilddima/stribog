module Stribog
  # BinaryVector
  #
  # @author WildDima
  module Stage
    class Base
      attr_reader :prev_stage
      attr_reader :vector
      attr_accessor :n
      attr_accessor :sum
      attr_accessor :digest_length
      attr_accessor :hash_vector
      attr_accessor :message_vector
      attr_accessor :message_head
      attr_accessor :current_vector

      def initialize(prev_stage, vector = Stribog.vector)
        @prev_stage = prev_stage
        @vector = vector
      end

      def call
        raise NotImplementedYet
      end

      protected

      def prev_stage_call
        @prev_stage_call ||= prev_stage.call
      end

      def field_vector(value:, size: 64)
        vector.new(Array.new(size, value))
      end

      def empty_vector(size: 64)
        field_vector(value: 0, size: size)
      end

      def slice_message_head(message_vector)
        vector.new(message_vector.vector[0...-HASH_LENGTH/8])
      end

      # Method, which slices head of tail
      def slice_message_tail(message_vector)
        vector.new(message_vector.vector[-HASH_LENGTH/8..-1])
      end

      # Compression method
      def compress(message:, hash_vector:, n: empty_vector)
        CompressionFunc.new(n, message, hash_vector).call
      end

      def addition_in_ring(first, second, ring = (2*8)**HASH_LENGTH, size: 64)
        vector.convert((first + second) % ring)
      end
    end
  end
end

