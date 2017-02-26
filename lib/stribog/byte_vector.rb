module Stribog
  # byte_array
  #
  # @author WildDima
  class ByteVector
    include Enumerable

    attr_reader :vector

    def self.convert(vector)
      case vector
      when String
        new(vector.unpack('C*'))
      when Numeric
        new([vector.to_s(2)].pack('B*').unpack('C*'))
      end
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

    def addition(size: 64)
      return self if vector.size >= size
      self.class.new(Array.new(size - vector.size, 0) + vector)
    end

    def padding(size: 64)
      return self if vector.size >= size
      # (self.class.new([1]) + vector).addition_by_zeros(size: 512)
      self.class.new([1] + vector).addition(size: size)
    end

    def byte8
      @byte8 ||= vector.pack('C*').unpack('Q*')
    end

    def bit64
      @bit64 ||= byte8.map { |b| [b].pack('Q*').unpack('B*') }.flatten
    end

    def to_dec
      # to_s.to_i(2)
      vector.pack('C*').unpack('B*').first.to_i(2)
    end

    def to_hex
      to_s.to_i(2).to_s(16)
    end

    def to_s
      # vector.pack('C*')
      vector
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
      # raise 'DimensionError' unless (vector.size % 8).zero?
      # vector.each_slice(8).map { |byte| byte.join.to_i(2) }
      vector
    end

    def zero?
      # to_dec.zero?
      vector.any?(&:zero?)
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
