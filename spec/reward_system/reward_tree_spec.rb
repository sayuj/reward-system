# frozen_string_literal: true

require 'spec_helper'

describe RewardTree do
  describe '.add' do
    it 'adds a node to the tree' do
      subject.add(id: 'B', inviter: 'A')
      expect(subject.nodes.keys).to eq %w[A B]
    end
  end

  describe '.update' do
    it 'updates a node in the tree' do
      subject.add(id: 'B', inviter: 'A')
      subject.accept('B')
      expect(subject.nodes['B'].accepted).to eq true
    end
  end

  context 'points' do
    it 'add points to inviter for level 0 inviter' do
      subject.add(id: 'B', inviter: 'A')
      subject.accept('B')
      expect(subject.nodes['A'].points).to eq 1
    end

    it 'add points to inviter for level 0 - 1 inviters' do
      subject.add(id: 'B', inviter: 'A')
      subject.accept('B')
      subject.add(id: 'C', inviter: 'B')
      subject.accept('C')
      expect(subject.nodes['A'].points).to eq 1.5
    end

    it 'add points to inviter for level 0 - 2 inviters' do
      subject.add(id: 'B', inviter: 'A')
      subject.accept('B')
      subject.add(id: 'C', inviter: 'B')
      subject.accept('C')
      subject.add(id: 'D', inviter: 'C')
      subject.accept('D')
      subject.add(id: 'E', inviter: 'C')
      expect(subject.nodes['A'].points).to eq 1.75
    end
  end
end
