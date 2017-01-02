require_relative 'hash_params'

module Stribog
  # Compression
  #
  # @author WildDima
  class Compression
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
      BinaryVector.from_byte_array vector.to_byte_array
                                         .map { |byte| PI[byte] }
    end

    # rubocop:disable Style/EachWithObject
    def permutation_t(vector)
      BinaryVector.from_byte_array(
        vector.to_byte_array
              .each.with_index.inject([]) do |b_arr, (byte, index)|
                b_arr[T[index]] = byte
                b_arr
              end
      )
    end
    # rubocop:enable Style/EachWithObject

    def linear_transformation(vector)
      BinaryVector.from_byte_array(
        vector.each_slice(64).map do |byte8|
          small_linear_transformation(BinaryVector.new(byte8)).to_dec
        end,
        size: 64
      )
    end

    def small_linear_transformation(vector)
      BinaryVector.from_byte(
        not_zeros_indexes(vector)
          .inject(0) { |acc, elem| acc ^ MATRIX_A[elem] }
      ).addition_by_zeros(size: 64)
    end

    # rubocop:disable Style/EachWithObject
    def func_e(first_vector, second_vector)
      vectors = CONSTANTS_C
                .inject(v1: first_vector.dup,
                        v2: second_vector.dup) do |vs, const|
        vs[:v2] = lpsx_func(vs[:v1], vs[:v2])
        vs[:v1] = lpsx_func(vs[:v1], BinaryVector.from_byte(const.to_i(16),
                                                            size: 512))
        vs
      end
      vectors[:v1] ^ vectors[:v2]
    end
    # rubocop:enable Style/EachWithObject

    def not_zeros_indexes(vector)
      vector.map.with_index do |bit, index|
        next if bit.zero?
        index
      end.compact
    end
  end
end
