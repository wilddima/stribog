require 'stribog/version'
require 'pry'
require 'pry-byebug'
# Stribog gost
#
# @author WildDima
module Stribog
  require_relative './stribog/create_hash'
  require_relative './stribog/hash_params'
  require_relative './stribog/compression_func'
  require_relative './stribog/binary_vector'
  require_relative './stribog/digest'
  require_relative './stribog/byte_vector'
  require_relative './stribog/stage/base'
  require_relative './stribog/stage/initial'
  require_relative './stribog/stage/compression'
  require_relative './stribog/stage/final'

  HASH_LENGTH = 512

  def self.vector
    ByteVector
  end
end
