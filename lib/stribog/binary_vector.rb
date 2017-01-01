module Stribog
  # BinaryVector
  #
  # @author WildDima
  class BinaryVector
    include Enumerable

    class << self
      def from_byte(byte, size: 8)
        new(byte.to_s(2).chars.map(&:to_i)).addition_to(size: size)
      end

      def from_byte_array(byte_array, size: 8)
        new(byte_array.map { |byte| from_byte(byte, size: size).to_a }
                      .inject([]) { |acc, elem| acc + elem })
      end
    end

    def initialize(vector)
      @vector = vector
      raise 'NotBinaryError' unless binary?
    end

    def ^(other)
      raise 'DimensionError' unless according_dimension?(other)
      self.class.new @vector.map.with_index { |bit, index| bit ^ other[index] }
    end

    def +(other)
      self.class.new @vector + other.to_a
    end

    def addition_to(size: 512)
      return self if @vector.size >= size
      self.class.new(Array.new(size - @vector.size, 0) + @vector)
    end

    def to_dec
      to_s.to_i(2)
    end

    def to_hex
      to_s.to_i(2).to_s(16)
    end

    def to_s
      @vector.join
    end

    def size
      @vector.size
    end

    def [](index)
      @vector[index]
    end

    def each
      @vector.each do |v|
        yield(v)
      end
    end

    def to_a
      @vector
    end

    def to_byte_array
      raise 'DimensionError' unless (@vector.size % 8).zero?
      @vector.each_slice(8).map { |byte| byte.join.to_i(2) }
    end

    def zero?
      to_dec.zero?
    end

    private

    def binary?
      @vector.all? { |el| [0, 1].include? el }
    end

    def according_dimension?(vector)
      @vector.size == vector.size
    end
  end
end
