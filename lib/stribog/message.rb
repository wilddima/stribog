module Stribog
  # Message
  #
  # @author WildDima
  class Message
    private_class_method :new

    attr_accessor :message, :vector

    def initialize(message, vector)
      @message = message
      @vector = vector
    end

    class << self
      def from_bin(bin)
        new bin_to_hex(bin), bin
      end

      def from_hex(hex)
        new hex, hex_to_bin(hex)
      end

      def from_string(string)
        new string, BinaryVector.new(string.unpack('B*')[0].chars.map(&:to_i))
      end

      def from_path(path)
        file = File.read(path)
        new file, file.unpack('B*')
      end

      def hex_to_bin(hex)
        BinaryVector.new(hex.chars.map do |x|
                           bin = x.to_i(16).to_s(2)
                           '0' * (4 - bin.length) + bin
                         end.join.chars.map(&:to_i))
      end

      def bin_to_hex(bin)
        bin.to_dec.to_s(16)
      end
    end

    def addition_to(size: 512)
      return if vector.size >= size
      (BinaryVector.new([1]) + vector).addition_to(size: 512)
    end

    def size
      @vector.size
    end

    private

    def to_vector(message)
      BinaryVector.new message.to_bits
    end

    def to_bits(byteorder: :big)
      case byteorder
      when :big
        message.unpack('B*')
      when :small
        message.unpack('b*')
      else
        raise ArgumentError,
              "byteorder must be equal to :big or :small, not: #{byteorder}"
      end
    end
  end
end
