require 'stribog/version'
# require 'pry'
# require 'pry-byebug'
# Stribog gost
#
# @author WildDima
module Stribog
  require 'stribog/create_hash'
  require 'stribog/hash_params'
  require 'stribog/compression_func'
  require 'stribog/digest'
  require 'stribog/byte_vector'
  require 'stribog/stage/base'
  require 'stribog/stage/initial'
  require 'stribog/stage/compression'
  require 'stribog/stage/final'

  HASH_LENGTH = 512

  def self.vector
    ByteVector
  end
end
