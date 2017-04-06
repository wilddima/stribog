require 'spec_helper'

describe Stribog::ByteVector do
  subject { Stribog::ByteVector }
  let(:vector1) { subject.convert 'q' }
  let(:vector2) { subject.convert 'w' }
  let(:vector3) { subject.new [0, 0, 0, 0, 0, 0, 2, 0] }
  let(:vector4) { subject.new [155, 190, 66, 172, 89, 98, 109, 77,
                               95, 105, 11, 42, 140, 97, 22, 243,
                               166, 186, 189, 107, 168, 85, 219, 56,
                               203, 238, 86, 144, 96, 98, 73, 101,
                               135, 62, 119, 34, 221, 92, 183, 237,
                               45, 252, 27, 234, 76, 86, 217, 93,
                               83, 15, 110, 40, 228, 90, 161, 229,
                               178, 11, 81, 104, 98, 133, 20, 102] }
  let(:empty_vector) { subject.convert '' }

  context 'create vector' do
    let(:string1) { 'qwerty' }
    let(:string2) { '' }

    it 'should return convert instance correct' do
      expect(subject.convert(string1).vector).to eq([113, 119, 101, 114, 116, 121])
      expect(subject.convert(string2).vector).to eq([])
    end
  end

  context '#+' do
    it 'should return new vector contains concatenation of two' do
      expect((vector1 + vector2).vector).to eq([113, 119])
      expect((vector1 + empty_vector).vector).to eq([113])
      expect((empty_vector  + empty_vector).vector).to eq([])
    end

    it 'should return new object' do
      expect((vector1 + vector2).object_id).not_to eq(vector1.object_id)
      expect((vector1 + vector2).object_id).not_to eq(vector2.object_id)
    end
  end

  context '#^' do
    it 'should return new vector contains xor of two' do
      expect((vector1 ^ vector2).vector).to eq([6])
      expect((vector1 ^ empty_vector).vector).to eq([113])
      expect((vector3 ^ vector4).vector).to eq((vector4 ^ vector3).vector)
      expect((empty_vector ^ empty_vector).vector).to eq([])
    end
  end

  context '#addition' do
    let(:vector) { subject.convert '1234567890' }

    it 'should return new vector addition by zeros' do
      expect((vector.addition).size).to eq(64)
      expect((vector.addition(size: 32)).size).to eq(32)
      expect((vector.addition(size: 16).vector)).to eq([0, 0, 0, 0, 0, 0, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48])
    end
  end

  context '#padding' do
    let(:vector) { subject.convert '1234567890' }

    it 'should return new vector addition by padding' do
      expect((vector.padding).size).to eq(64)
      expect((vector.padding(size: 32)).size).to eq(32)
      expect((vector.padding(size: 16).vector)).to eq([0, 0, 0, 0, 0, 1, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48])
    end
  end
end
