require 'spec_helper'

describe Stribog::ByteVector do
  subject { Stribog::ByteVector }
  let(:vector1) { subject.convert 'q' }
  let(:vector2) { subject.convert 'w' }
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
    it 'should return new vector contains concatenation of two' do
      expect((vector1 ^ vector2).vector).to eq([6])
      expect((vector1 ^ empty_vector).vector).to eq([113])
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
