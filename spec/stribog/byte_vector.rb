require 'spec_helper'

describe Stribog::ByteVector do
  context 'create vector' do
    subject { Stribog::ByteVector }
    let(:string1) { 'qwerty' }
    let(:string2) { '' }

    it 'should return convert instance correct' do
      expect(subject.convert(string1).vector).to eq([113, 119, 101, 114, 116, 121])
      expect(subject.convert(string2).vector).to eq([])
    end
  end

  context '#+' do
    subject { Stribog::ByteVector }
    let(:vector1) { subject.convert 'q' }
    let(:vector2) { subject.convert 'w' }
    let(:empty_vector) { subject.convert '' }

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
    subject { Stribog::ByteVector }
    let(:vector1) { subject.convert 'q' }
    let(:vector2) { subject.convert 'w' }
    let(:empty_vector) { subject.convert '' }

    it 'should return new vector contains concatenation of two' do
      expect((vector1 ^ vector2).vector).to eq([6])
      expect((vector1 ^ empty_vector).vector).to eq([113])
      expect((empty_vector ^ empty_vector).vector).to eq([])
    end
  end
end
