module Stribog
  # byte_array
  #
  # @author WildDima
  class ByteVector
    include Enumerable

    attr_reader :vector

    def self.convert(vector)
      new(vector.unpack('C*'))
    end

    def initialize(vector)
      @vector = vector
    end

    def ^(other)
      # raise 'DimensionError' unless according_dimension?(other)
      self.class.new vector.map
                           .with_index { |bit, index| bit ^ (other[index] || 0) }
    end

    def +(other)
      self.class.new vector + other.to_a
    end

    def addition_by_zeros(size: 512)
      return self if vector.size >= size
      self.class.new(Array.new(size - vector.size, 0) + @vector)
    end

    def addition_bit_padding(size: 512)
      return self if vector.size >= size
      (self.class.new([1]) + vector).addition_by_zeros(size: 512)
    end

    def to_dec
      to_s.to_i(2)
    end

    def to_hex
      to_s.to_i(2).to_s(16)
    end

    def to_s
      vector.join
    end

    def size
      vector.size
    end

    def [](index)
      vector[index]
    end

    def each
      vector.each do |v|
        yield(v)
      end
    end

    def to_a
      vector
    end

    def to_byte_array
      raise 'DimensionError' unless (vector.size % 8).zero?
      vector.each_slice(8).map { |byte| byte.join.to_i(2) }
    end

    def zero?
      to_dec.zero?
    end

    private

    def binary?
      vector.all? { |el| [0, 1].include? el }
    end

    def according_dimension?(second_vector)
      vector.size == second_vector.size
    end
  end
end
