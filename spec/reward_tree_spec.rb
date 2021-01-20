require 'spec_helper'

describe RewardTree do
  describe '.add' do
    it 'adds a node to the tree' do
      subject.add(id: 'B', inviter: 'A', accepted: false)
      expect(subject.nodes.keys).to eq ['A', 'B']
    end
  end

  describe '.update' do
    it 'updates a node in the tree' do
      subject.add(id: 'B', inviter: 'A', accepted: false)
      subject.update(id: 'B', accepted: true)
      expect(subject.nodes['B'].accepted).to eq true
    end
  end

  context 'points' do
    it 'add points to inviter for lovel 0 inviter' do
      subject.add(id: 'A', inviter: 'B', accepted: true)
      expect(subject.nodes['B'].points).to eq 1
    end

    it 'add points to inviter for lovel 0 - 1 inviters' do
      subject.add(id: 'B', inviter: 'A', accepted: true)
      subject.add(id: '`C', inviter: 'B', accepted: true)
      expect(subject.nodes['A'].points).to eq 1.5
    end

    it 'add points to inviter for lovel 0 - 2 inviters' do
      subject.add(id: 'B', inviter: 'A', accepted: true)
      subject.add(id: 'C', inviter: 'B', accepted: true)
      subject.add(id: 'D', inviter: 'C', accepted: true)
      subject.add(id: 'E', inviter: 'C', accepted: false)
      expect(subject.nodes['A'].points).to eq 1.75
    end
  end
end
