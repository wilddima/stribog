module Stribog
  # Compression
  #
  # Class implements compression function of GOST R 34.11-2012 algorithm.
  # @author WildDima
  class CompressionFunc
    include HashParams

    def initialize(n, message, hash_vector)
      @n = n
      @message = message
      @hash_vector = hash_vector
    end

    def call
      vector = lpsx_func @n, @hash_vector
      vector = func_e vector, @message
      vector = vector ^ @hash_vector
      vector ^ @message
    end

    private

    def lpsx_func(first_vector, second_vector)
      linear_transformation(
        permutation_t(
          replacement_pi(
            first_vector ^ second_vector
          )
        )
      )
    end

    def replacement_pi(vector)
      ByteVector.new vector.map { |byte| PI[byte] }
    end

    # rubocop:disable Style/EachWithObject
    def permutation_t(vector)
      ByteVector.new(
        vector.each.with_index.inject([]) do |b_arr, (byte, index)|
                b_arr[T[index]] = byte
                b_arr
               end.map(&:to_i)
      )
    end
    # rubocop:enable Style/EachWithObject

    def linear_transformation(vector)
      ByteVector.new(
        vector.bit64.map do |byte8|
          small_linear_transformation(byte8)
        end.flatten
      )
    end

    def small_linear_transformation(vector)
      # REFACTOR
      ByteVector.convert(
        not_zeros_indexes(vector)
          .inject(0) { |acc, elem| acc ^ MATRIX_A[elem] }
      ).to_a
    end

    # rubocop:disable Style/EachWithObject
    def func_e(first_vector, second_vector)
      vectors = CONSTANTS_C
                .inject(v1: first_vector.dup,
                        v2: second_vector.dup) do |vs, const|
        vs[:v2] = lpsx_func(vs[:v1], vs[:v2])
        vs[:v1] = lpsx_func(vs[:v1], ByteVector.convert(const))
        vs
      end
      vectors[:v1] ^ vectors[:v2]
    end
    # rubocop:enable Style/EachWithObject

    def not_zeros_indexes(vector)
      vector.chars.map.with_index do |bit, index|
        next if bit == '0'
        index
      end.compact
    end
  end
end
